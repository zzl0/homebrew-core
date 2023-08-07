class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2023.08.07.00/proxygen-v2023.08.07.00.tar.gz"
  sha256 "7931d8cfe93642860d4273adb89d533dd26643756a77a04a76496e4e9de1eba3"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "017f0f8345e55e6d48835822059848d8361977a8ed74b09538810696edb4b67c"
    sha256 cellar: :any,                 arm64_monterey: "b003396f4e561f3fa48de10c85324ae7b111fcf952017eb4afa1b66bd0537ff1"
    sha256 cellar: :any,                 arm64_big_sur:  "63566f8c7b0150f46a937a6583ee542a199dec69f00710b7e3357fdec6a9a5ce"
    sha256 cellar: :any,                 ventura:        "d165160d7ddd3c00f944579077fae34b94910f07f0f7a0e88b148db1e0df737e"
    sha256 cellar: :any,                 monterey:       "7ff04ac95e6e9d9a7ebff4138e06602f1b2af76304a0c053b021f986c3cb5423"
    sha256 cellar: :any,                 big_sur:        "4a791776673aa8bc374f2c82d55c63b43720f04443ce0b70b3e4f6ed5d6275ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f8ca175f4b8269921c115122c51d8baea5d163412e496b65db18690699592be"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pid = spawn bin/"proxygen_echo"
    sleep 5
    system "curl", "-v", "http://localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end
