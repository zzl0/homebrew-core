class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/refs/tags/v2023.10.23.00.tar.gz"
  sha256 "87c6dbc8b37190ae0030f06c029de1fd83f9aab4fd53d7fc67d16be517e7c50e"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5244a0fa103f708fa4697146cc5f6e24a27b2fc31df56278b76a16f4ac46b8dc"
    sha256 cellar: :any,                 arm64_ventura:  "a804cb447a5832c79f7aeb637d84a1d474367de0ba65692575a9a6cd06b14998"
    sha256 cellar: :any,                 arm64_monterey: "54bdf21212006e0b6261913d86b93ad84b01d0042db946d8cf72a51061297b19"
    sha256 cellar: :any,                 sonoma:         "98dcee81cade744a4d4f7fb50c2746058e78ea3b06fba9de3e3b6f3d1abc1f89"
    sha256 cellar: :any,                 ventura:        "f326274205f69d0ce33185f40396379651a5a1246da71f41c5688310ad55095e"
    sha256 cellar: :any,                 monterey:       "3e7501208cb8d991c1da31e5a08bd461474b8e3b2ff29ea60a28cda05527ec72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29440e3408ccf4a0a79db7eb628e6b8b46179dadca0406c18feb8a2f6a271c48"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)
    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix
    ENV.append_to_cflags "-fPIC" if OS.linux?

    # Setting `BUILD_SHARED_LIBS=ON` fails the build.
    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"
  end

  test do
    (testpath/"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath/"gen-cpp2", :exist?
    assert_predicate testpath/"gen-cpp2", :directory?
  end
end
