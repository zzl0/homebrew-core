class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.123.0.0.tar.gz"
  sha256 "17254dc8bedd081e18c118881df13bffe42b6175836f998e87cc27ea0c4d8949"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ca88d6a3cb310b366c419f699a8a811b8742906c4d66d0655fc30c1b2a3bb5c"
    sha256 cellar: :any,                 arm64_monterey: "28a9d3bbc353dccd450607ab0592d43645954b2d52dc388928e032925fdfe1f5"
    sha256 cellar: :any,                 arm64_big_sur:  "65686e68e713323b90c22118ada6590cb176b4cf83d2e1b6a44265e22625d4e9"
    sha256 cellar: :any,                 ventura:        "436e18f57b3bc003471e3f8c0e021671bf65a03067087c2eb3ecb599a9a0459d"
    sha256 cellar: :any,                 monterey:       "24cdc824e5f45852dbd7b8a39f231ace7a0fb0ae1bc0833ac2ffb2cb49b1b5ba"
    sha256 cellar: :any,                 big_sur:        "ada9edb55e92eda3952efafbe87d91a904d44e2f3df3431353cc9311e990a123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ff35f52c38e498cbfb8d45a1ae4c6e66fa51d3580d2c8499fb963803f718600"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/3.123.0.0.tar.gz"
    sha256 "9dac9d89e8485595a92db9d5464d5f54e487879382cd8dd708e20f5d022ca531"
  end

  def install
    (buildpath/"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    inreplace "project.cmake", "${listDir}/thirdparty/pcre2\n", ""
    inreplace "groups/bdl/group/bdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groups/bdl/bdlpcre/bdlpcre_regex.h", "#include <pcre2/pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "bde-tools/cmake/toolchains/#{OS.kernel_name.downcase}/default.cmake"
    args = std_cmake_args + %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=./bde-tools/cmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}
      -DPYTHON_EXECUTABLE=#{which("python3.11")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMake install step does not conform to FHS
    lib.install Dir[bin/"so/64/*"]
    lib.install lib/"opt_exc_mt_shr/cmake"
  end

  test do
    assert_equal version, resource("bde-tools").version, "`bde-tools` resource needs updating!"

    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~EOS
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end
