class GnuCobol < Formula
  desc "COBOL85-202x compiler supporting lots of dialect specific extensions"
  homepage "https://www.gnu.org/software/gnucobol/"
  url "https://ftp.gnu.org/gnu/gnucobol/gnucobol-3.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gnucobol/gnucobol-3.2.tar.xz"
  sha256 "3bb48af46ced4779facf41fdc2ee60e4ccb86eaa99d010b36685315df39c2ee2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?gnucobol[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c04cb267f5f67d73c5b0a767b63197da96dec54ce813217759120a4f92a654a8"
    sha256 arm64_monterey: "bd5300d24e94a25f53c97ce6168d7ed2fde90be9eca29bea70443927c8936746"
    sha256 arm64_big_sur:  "f0b1a2b68a171c912545b818a80c36a317e1d6c3d3e8d19caad482fe2de3d71e"
    sha256 ventura:        "95f1fe3c827987acabadd7254d1fb220fd1339e5e7e23f4db06703023437dfcd"
    sha256 monterey:       "11dcc824e7db792595d399cdd692dd45e0b6d023554ebdd54782e18fd2f8e1c8"
    sha256 big_sur:        "a7798d2cc900be3cc77e7adc6231e3bd651b00f2eebb19235b1f0df22812ad3c"
    sha256 x86_64_linux:   "4bf957f586d155f1034ac90ac24edff1253e9de935336680689d85f0bbdcf45c"
  end

  head do
    url "https://svn.code.sf.net/p/gnucobol/code/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "gettext" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build

    # GnuCOBOL 4.x+ (= currently only on head) features more backends
    # and multiple indexed handlers, so we add dependencies for those here
    depends_on "lmdb"
    depends_on "unixodbc"
    # TODO: add "visam" and --with-visam, once formula is added
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "json-c"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    # Avoid shim references in binaries on Linux.
    ENV["LD"] = "ld" unless OS.mac?

    args = %w[
      --disable-silent-rules
      --with-libiconv-prefix=/usr
      --with-libintl-prefix=/usr
      --with-json=json-c
      --with-xml2
      --with-curses=ncurses
      --with-db
    ]

    if build.head?
      # GnuCOBOL 4.x+ features (= currently only on head)
      args += %w[
        --with-lmdb
        --with-odbc
        --with-indexed=db
      ]

      # bootstrap, go with whatever gettext we have
      inreplace "configure.ac", "AM_GNU_GETTEXT_VERSION", "AM_GNU_GETTEXT_REQUIRE_VERSION"
      system "build_aux/bootstrap", "install"
    end
    system "./configure", *std_configure_args,
                          *args

    system "make", "install"
  end

  test do
    (testpath/"hello.cob").write <<~EOS
            * COBOL fixed-form must be indented
      000001 IDENTIFICATION DIVISION.
      000002 PROGRAM-ID. hello.
      000003 PROCEDURE DIVISION.
      000004 DISPLAY "Hello World!".
      000005 STOP RUN.
    EOS

    # create test executable and run it, with verbose output
    system "#{bin}/cobc", "-x", "-j", "-v", "hello.cob"
    # now again as shared object (will also run cobcrun)
    system "#{bin}/cobc", "-m", "-j", "-v", "hello.cob"
  end
end
