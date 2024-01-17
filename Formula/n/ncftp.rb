class Ncftp < Formula
  desc "FTP client with an advanced user interface"
  homepage "https://www.ncftp.com/"
  url "https://www.ncftp.com/public_ftp/ncftp/ncftp-3.2.7-src.tar.xz"
  mirror "https://fossies.org/linux/misc/ncftp-3.2.7-src.tar.xz"
  sha256 "d41c5c4d6614a8eae2ed4e4d7ada6b6d3afcc9fb65a4ed9b8711344bef24f7e8"
  license "ClArtistic"

  livecheck do
    url "https://www.ncftp.com/download/"
    regex(/href=.*?ncftp[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "e856ea911ceee8a435262a8b6352eb48a59a1ccb6a1dc01a44c90067a53405aa"
    sha256 arm64_ventura:  "f35284c1451cccd59675fff89f8a285aabfa287346928f1a3009db65074ec405"
    sha256 arm64_monterey: "0d10c2e5a5cd32d495bb7cf1b16de23c8335658097ee209397170ccbec21e164"
    sha256 arm64_big_sur:  "1fc3f5a43b5e4e23f2bac0046acaf8f746d5d07e0eb6cf60d593830fb3acbf13"
    sha256 sonoma:         "806a2b647a6d3eb7b0dd6ec3fe8615429a0c01718c5a3ea7cc322a0fae7d6bcb"
    sha256 ventura:        "e83dbafd6d2cc7885ac986aa7d1452fa88fd73f6947dd7d6c8ef94c1dd0e4de0"
    sha256 monterey:       "f8a7be7e00a9ed10c22c5396e8c67f1f8697cfe117c003a4e5a62f3a9f13f33e"
    sha256 big_sur:        "be10854d86393b58f542fbe778bf650c90a9635fbd14eff8149459838c4455c6"
    sha256 catalina:       "c5759f94e328047e35a3f22c63ecf7bf7051edbc68432b3eb9db6c61d8f84bb2"
    sha256 mojave:         "381492aa09e004859600ffc441ebd4dfe1c75685099debf5a7c283c15785a26c"
    sha256 x86_64_linux:   "4e3ce2c25f180954ba28f3b4c630ede2dd4c798df59f5f5aa13fbfa2cd4f6acc"
  end

  uses_from_macos "ncurses"

  # fix conflicting types for macos build, sent the patch to support@ncftp.com
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", "--disable-universal",
                          "--disable-precomp",
                          "--with-ncurses",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ncftp", "-F"
  end
end

__END__
diff --git a/sio/DNSUtil.c b/sio/DNSUtil.c
index 0d542bb..eb7e867 100644
--- a/sio/DNSUtil.c
+++ b/sio/DNSUtil.c
@@ -12,7 +12,7 @@
 #	define Strncpy(a,b,s) strncpy(a, b, s); a[s - 1] = '\0'
 #endif

-#if (((defined(MACOSX)) && (MACOSX < 10300)) || (defined(AIX) && (AIX < 430)) || (defined(DIGITAL_UNIX)) || (defined(SOLARIS)) || (defined(SCO)) || (defined(HPUX)))
+#if ((defined(AIX) && (AIX < 430)) || (defined(DIGITAL_UNIX)) || (defined(SOLARIS)) || (defined(SCO)) || (defined(HPUX)))
 extern int getdomainname(char *name, gethostname_size_t namelen);
 #endif
