class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/3.1.3.tar.gz"
  sha256 "8314438428069ffeca15e2644eaa51284f884b7a1b2ddfdafe12152581b13398"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "ff9b1fcd2fd2e89a183f0e37f7bb7d5d7e396c79258e9f471abbe4a907295730"
    sha256 arm64_monterey: "2507148018670a03840c55f42c77b4aba762b25559a39ffd3052bba9a5bdfee7"
    sha256 arm64_big_sur:  "702a83f5341f84972b45cfd82c0165ed3c94810b852fcbd699db224bb69aa5aa"
    sha256 ventura:        "e518731327b5d834a211d21be1bc1497441d4375a39b69b7a0e56195966e6037"
    sha256 monterey:       "dddadb2cee1428831d00c94b6340b80485e2d1ea0dc2b0e7c261d8ee589ae2d1"
    sha256 big_sur:        "02ceb63f44555c33376f778b28ff1973b4ef7aeab0a6615ecc1c59b83c2618da"
    sha256 x86_64_linux:   "f880f67988e7a7a76237fc0ecf5df8ee257b924cc5d6445270108aa4d61e7745"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__current_path(std::__1::error_code*)"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
