class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://github.com/v6d-io/v6d/releases/download/v0.16.5/v6d-0.16.5.tar.gz"
  sha256 "03245928b3c429920d750ab3e3f8ed1f3d68e58c024f32647971a35f34260714"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256                               arm64_ventura:  "42b4b716dbf1afb833fc1bc7498f86f66594e11965ad473af0a0c610c9fdd4d7"
    sha256                               arm64_monterey: "b4c41dd0e67c434e5300932e44518b42c34a66919592927457207acff46bb71b"
    sha256                               arm64_big_sur:  "3b134c7d405c224ad2957507fc37c10c645e200cef96d16e93cfe5163e634e93"
    sha256                               ventura:        "a740c317ad6335d635906f3ea21a27cd67c83a5e15c76b08ce25ef241fa3db76"
    sha256                               monterey:       "6d7570c03fc6264f837e38ef3ecb72a6f56e03202d696dda73fce9bf4167d959"
    sha256                               big_sur:        "3a2453e45ad13e444f0701ce38cb07ef4bc53147af6169a471c05e671bf35d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9616da1ad8eddc33927b4369f08612389d52eb4602e7ed9622c02106e1a01a43"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "python@3.11" => :build
  depends_on "apache-arrow"
  depends_on "boost"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "libgrape-lite"
  depends_on "open-mpi"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "redis"

  fails_with gcc: "5"

  def install
    python = "python3.11"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{which(python)}",
                    "-DUSE_EXTERNAL_ETCD_LIBS=ON",
                    "-DUSE_EXTERNAL_REDIS_LIBS=ON",
                    "-DUSE_EXTERNAL_HIREDIS_LIBS=ON",
                    "-DBUILD_VINEYARD_TESTS=OFF",
                    "-DUSE_LIBUNWIND=OFF",
                    "-DLIBGRAPELITE_INCLUDE_DIRS=#{Formula["libgrape-lite"].opt_include}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <memory>

      #include <vineyard/client/client.h>

      int main(int argc, char **argv) {
        vineyard::Client client;
        VINEYARD_CHECK_OK(client.Connect(argv[1]));

        std::shared_ptr<vineyard::InstanceStatus> status;
        VINEYARD_CHECK_OK(client.InstanceStatus(status));
        std::cout << "vineyard instance is: " << status->instance_id << std::endl;

        return 0;
      }
    EOS

    system ENV.cxx, "test.cc", "-std=c++17",
                    "-I#{Formula["apache-arrow"].include}",
                    "-I#{Formula["boost"].include}",
                    "-I#{include}",
                    "-I#{include}/vineyard",
                    "-I#{include}/vineyard/contrib",
                    "-L#{Formula["apache-arrow"].lib}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{lib}",
                    "-larrow",
                    "-lboost_thread-mt",
                    "-lboost_system-mt",
                    "-lvineyard_client",
                    "-o", "test_vineyard_client"

    # prepare vineyardd
    vineyardd_pid = spawn bin/"vineyardd", "--norpc",
                                           "--meta=local",
                                           "--socket=#{testpath}/vineyard.sock"

    # sleep to let vineyardd get its wits about it
    sleep 10

    assert_equal("vineyard instance is: 0\n", shell_output("./test_vineyard_client #{testpath}/vineyard.sock"))
  ensure
    # clean up the vineyardd process before we leave
    Process.kill("HUP", vineyardd_pid)
  end
end
