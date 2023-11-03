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
    sha256 cellar: :any,                 arm64_sonoma: "47237c675e0d58452a5af3af244b6184cadedb63301c838af1c37fadcf6acca3"
    sha256 cellar: :any,                 sonoma:       "f97272437dba25f87e9572fb5fb727340f6d07f2876133aa8628f8c3357447c5"
    sha256 cellar: :any,                 monterey:     "2e5195547b9d5783ed68956e0c158d0f9de968da495b0cecf18b76d787746638"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "edbf0180a035cb6d807a858c590176a01d169d0d0fe84dd6b24505ad05433b18"
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
