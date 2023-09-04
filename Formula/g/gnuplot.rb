class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.9/gnuplot-5.4.9.tar.gz"
  sha256 "a328a021f53dc05459be6066020e9a71e8eab6255d3381e22696120d465c6a97"
  license "gnuplot"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "d40df5c11e7f90b5ef3c489dff54bf405cf9125cda3de61f8fc24d0b3fcafd05"
    sha256 arm64_monterey: "2b0b0ae3446b80af02452bb2ff1f2a787c41ac3627bd7499bbb96ce35bac62ae"
    sha256 arm64_big_sur:  "52ed9426cb08b1bf9140ba75dcd6ef7b398fcf00c8f7246f1c93868f7b6570ab"
    sha256 ventura:        "3bea5e9917bda062beed8195e92bf1a4a723d344a522d1d1cd028e393e65d797"
    sha256 monterey:       "d416ea34c5dced922f6044f8d7ad0e273de282cd50182292f404bb0e5ff00d0f"
    sha256 big_sur:        "7d3ec01a6fc4c7ead43f764f26153a7c4346a84fecb87e4c015ac661074fdc2e"
    sha256 x86_64_linux:   "8a135d55cfe11b50e512cdad44b0a4be38bafa39d13f5828027fee46057cc032"
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt"
  depends_on "readline"

  fails_with gcc: "5"

  # Fixes `uic-qt6: No such file or directory`
  # Fixes `lrelease-qt6: No such file or directory`
  # https://sourceforge.net/p/gnuplot/bugs/2649/
  patch :DATA

  def install
    args = %W[
      --disable-silent-rules
      --with-readline=#{Formula["readline"].opt_prefix}
      --disable-wxwidgets
      --with-qt
      --without-x
      --without-latex
      LRELEASE=#{Formula["qt"].bin}/lrelease
      MOC=#{Formula["qt"].pkgshare}/libexec/moc
      RCC=#{Formula["qt"].pkgshare}/libexec/rcc
      UIC=#{Formula["qt"].pkgshare}/libexec/uic
    ]

    if OS.mac?
      # pkg-config files are not shipped on macOS, making our job harder
      # https://bugreports.qt.io/browse/QTBUG-86080
      # Hopefully in the future gnuplot can autodetect this information
      # https://sourceforge.net/p/gnuplot/feature-requests/560/
      qtcflags = []
      qtlibs = %W[-F#{Formula["qt"].opt_prefix}/Frameworks]
      %w[Core Gui Network Svg PrintSupport Widgets Core5Compat].each do |m|
        qtcflags << "-I#{Formula["qt"].opt_include}/Qt#{m}"
        qtlibs << "-framework Qt#{m}"
      end

      args += %W[
        QT_CFLAGS=#{qtcflags.join(" ")}
        QT_LIBS=#{qtlibs.join(" ")}
      ]
    end

    ENV.append "CXXFLAGS", "-std=c++17" # needed for Qt 6
    system "./prepare" if build.head?
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] },
                          *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_predicate testpath/"graph.txt", :exist?
  end
end
__END__
diff --git a/configure b/configure
index c918ea8..019dcc0 100755
--- a/configure
+++ b/configure
@@ -16393,12 +16393,17 @@ fi
           UIC=${QT6LOC}/uic
           MOC=${QT6LOC}/moc
           RCC=${QT6LOC}/rcc
-      else
+      elif test "x${UIC}" = "x"; then
           UIC=uic-qt6
           MOC=moc-qt6
           RCC=rcc-qt6
       fi
-      LRELEASE=lrelease-qt6
+      QT6BIN=`$PKG_CONFIG --variable=bindir Qt6Core`
+      if test "x${QT6BIN}" != "x"; then
+          LRELEASE=${QT6BIN}/lrelease
+      elif test "x${LRELEASE}" = "x"; then
+          LRELEASE=lrelease-qt6
+      fi
       CXXFLAGS="$CXXFLAGS -fPIC"
       { printf "%s\n" "$as_me:${as_lineno-$LINENO}: result: The Qt terminal will use Qt6." >&5
 printf "%s\n" "The Qt terminal will use Qt6." >&6; }
