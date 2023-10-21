class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.10/gnuplot-5.4.10.tar.gz"
  sha256 "975d8c1cc2c41c7cedc4e323aff035d977feb9a97f0296dd2a8a66d197a5b27c"
  license "gnuplot"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "86cc3fb83691b2ae56ecb6800597824a1b218953d67919383afa49cedca8cbae"
    sha256 arm64_ventura:  "a9969d9124b0a9ac3c3bc5a5f19e215bc3757a34e142beb888f76cd631441f66"
    sha256 arm64_monterey: "23519be29392ea57db23622bd5ed5cfc413c7a653bd3fd8b87f31489db326d2a"
    sha256 arm64_big_sur:  "895fe52a242f77ee6cb9e241980f803fe35d20318bb1fa6d4628a8c9e234d288"
    sha256 sonoma:         "f72c06e6a10f614136f4a35709270c1f4c45c9b5c32479067a3798854797918e"
    sha256 ventura:        "dce9d5e1c207f5742c204324b9a6cb97aff7f474ffa7725da510c7c82f7970e0"
    sha256 monterey:       "70543600a2b405793486fa519819fc8872edad5a12f0a4886e3b1d3a97ef5f02"
    sha256 big_sur:        "ae3a916cbce4f6b4fd55c694c147cba837be988ef9a1a4bb0f6d17683bceaa21"
    sha256 x86_64_linux:   "90328aa900398f630f6ef936f94c4c2298c3140d3146573fbca25da28813b119"
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
