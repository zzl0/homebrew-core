class Libunwind < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://www.nongnu.org/libunwind/"
  url "https://github.com/libunwind/libunwind/releases/download/v1.8.0/libunwind-1.8.0.tar.gz"
  sha256 "b6b3df40a0970c8f2865fb39aa2af7b5d6f12ad6c5774e266ccca4d6b8b72268"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2a0c1911181ba2f5161c33524b64bc60d1bcaa02b9e83070f806b0d3652b5d69"
  end

  keg_only "libunwind conflicts with LLVM"

  depends_on :linux
  depends_on "xz"
  depends_on "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libunwind.h>
      int main() {
        unw_context_t uc;
        unw_getcontext(&uc);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lunwind", "-o", "test"
    system "./test"
  end
end
