class Libantlr3c < Formula
  desc "ANTLRv3 parsing library for C"
  homepage "https://www.antlr3.org/"
  url "https://github.com/antlr/antlr3/archive/refs/tags/3.5.3.tar.gz"
  sha256 "a0892bcf164573d539b930e57a87ea45333141863a0dd3a49e5d8c919c8a58ab"
  license "BSD-3-Clause"

  livecheck do
    url "https://github.com/antlr/antlr3.git"
    regex(/^(?:(?:antlr|release)[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b7265d5141b9b1115b4db096b40a131aa140fe4a6b2d97a08152d880665ed196"
    sha256 cellar: :any,                 arm64_monterey: "192faf2b2502946c3a8b27cade6a6febbd579de8fb1b9da136c48ea6a74bc621"
    sha256 cellar: :any,                 arm64_big_sur:  "0ba9d61434c3b1a05ef0ff9bb86e1e6d238c91723383204daeb5115976b05b02"
    sha256 cellar: :any,                 ventura:        "f83b901e8bbe67b933aecaf5d0db440b228d892c23e4917d2aaf7c1518b3c555"
    sha256 cellar: :any,                 monterey:       "8fa311163c90642a02332aebc6b4bd77d24fc2d0a45ecbc6f5670acb54e29977"
    sha256 cellar: :any,                 big_sur:        "3e442dfcc1083a693b77995703d2a2bb5100d13dfbae8cf174816fd112e90cb5"
    sha256 cellar: :any,                 catalina:       "53bc5810ecd6cc4be26da750839d53981ebba6ad931e13005661e599cfd69501"
    sha256 cellar: :any,                 mojave:         "c4df9f53203a7e21abc1fb22bf74256017f646e9177606c7da6c222db16dd3cb"
    sha256 cellar: :any,                 high_sierra:    "2de7942e4bc89830c0d92bfda55e60a4ad82723430bcc7477abb5d1b1ade7f86"
    sha256 cellar: :any,                 sierra:         "a5e779c431e16bdaab829c774468ce11f8e7ea359412800e294433b011704541"
    sha256 cellar: :any,                 el_capitan:     "fea1cde8ae732cdbbffa6a6d329239b1da067d2b69424d53178e60309748c403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acd166cf59163343b31b229124ddf4e982c4fa42b196ec443b5ff8b02e12566a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    cd "runtime/C" do
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] },
                            "--disable-debuginfo",
                            "--enable-64bit",
                            "--disable-antlrdebug"

      system "make", "install"
    end
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <antlr3.h>
      int main() {
        if (0) {
          antlr3GenericSetupStream(NULL);
        }
        return 0;
      }
    EOS
    system ENV.cc, "hello.c", "-L#{lib}", "-lantlr3c", "-o", "hello", "-O0"
    system testpath/"hello"
  end
end
