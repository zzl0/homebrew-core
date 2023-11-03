class Gpsim < Formula
  desc "Simulator for Microchip's PIC microcontrollers"
  homepage "https://gpsim.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.32.0/gpsim-0.32.0.tar.gz"
  sha256 "8ef4fb64c993b205d943b300fb9dcb8cc0c4c9d0e8d8d47fdc088fe9c3c42468"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/gpsim/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/gpsim[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "ff38f5f57aec23966b25cdaae05ce47af0395ae78093e3bbc62435369377e462"
    sha256 cellar: :any,                 arm64_big_sur: "7c2f982e48f43bd5b4bf96bc789292d2e786be2cba23cda8b23303cb4f323ad9"
    sha256 cellar: :any,                 sonoma:        "8092f60096211d2ccd3e8d68915e6013abffd44489cf4b019ea372666c1aad2a"
    sha256 cellar: :any,                 monterey:      "67592314e36ca6c5c0bfa338ec40ba7b2c168665bbff42f280429866da401e3c"
    sha256 cellar: :any,                 big_sur:       "65f8044f61bd55813e73385c46ec6bb167c45ac9af373d14c544cdbdff932fb4"
    sha256 cellar: :any,                 catalina:      "7f92c6ae94438c73050aea08fa41c56b93efa9464855b3b0861b0bb3c6a08621"
    sha256 cellar: :any,                 mojave:        "00c585480ada4e552a32ee3f0e11bc68142ce4f6671eeb14badc51007d07be9f"
    sha256 cellar: :any,                 high_sierra:   "612ce9c2f03a5c6464aee9b9bdcd6884e434e457f515bbbc2adceb8417f1c6d1"
    sha256 cellar: :any,                 sierra:        "5a366b0dccfe1ff92aaed6d29f9bd5ca66806471b17e8941206e985f6bd8817a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b7d6c3c3efa789c2087087ce41658a08cb659273ac61dc5c8df05fa3a8bf6b7"
  end

  depends_on "gputils" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"
  depends_on "readline"

  # upstream bug report, https://sourceforge.net/p/gpsim/bugs/286/
  patch :DATA

  def install
    ENV.cxx11

    system "./configure", "--disable-gui",
                          "--disable-shared",
                          *std_configure_args
    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/gpsim", "--version"
  end
end

__END__
diff --git a/doc/Makefile.am b/doc/Makefile.am
index 69b3f13..f9c5dc4 100644
--- a/doc/Makefile.am
+++ b/doc/Makefile.am
@@ -1,6 +1,3 @@
-
-SUBDIRS=gpsim.html.LyXconv
-
 all: gpsim.ps gpsim.pdf
 
 gpsim.ps: gpsim.lyx
diff --git a/doc/Makefile.in b/doc/Makefile.in
index 2d7a0e8..cd72080 100644
--- a/doc/Makefile.in
+++ b/doc/Makefile.in
@@ -330,7 +330,6 @@ target_alias = @target_alias@
 top_build_prefix = @top_build_prefix@
 top_builddir = @top_builddir@
 top_srcdir = @top_srcdir@
-SUBDIRS = gpsim.html.LyXconv
 EXTRA_DIST = \
 	screenshots/breadboard.png \
 	screenshots/registerview.png \
