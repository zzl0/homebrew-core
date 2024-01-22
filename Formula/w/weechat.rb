class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.2.0.tar.xz"
  sha256 "32f6a6f213fb634db931e2ab8f01adb9a9b50e77faa1c52ca116efa320575a4a"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "1631a2c9479d11f14ded3f7d760e11267a3bbae9a5e4cff462ba63921d9630cd"
    sha256 arm64_ventura:  "e63c492315935e5d6e375585bbe053bacb221f63e75a8a2d05ae1b62bbaf8ddd"
    sha256 arm64_monterey: "18f16000722d5bce8c096156b8a8efee69cec5982a5271668e90a6990f4524d2"
    sha256 sonoma:         "9aa3f78ab2a7b846508871052b6dc9c0546d4eed6f60cff52bf39be3aa75df2b"
    sha256 ventura:        "255e758ec17b3c9b7adabfe4fe8b43ea32d726d5322e737abf6628aa6da14976"
    sha256 monterey:       "aa0bbfd355508a14bb32617e7a863503aee202c3f0c0af7b03d9d86b87d1d544"
    sha256 x86_64_linux:   "2015fbe512cd6b9e1d916aa55e0d3bcaf450cc84e9a8a9ee1f0ac86de5910e98"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.12"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  def python3
    which("python3.12")
  end

  def install
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "cmake/FindPython.cmake", " python3-embed ", " python-#{pyver}-embed "

    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    if OS.linux?
      args << "-DTCL_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
      args << "-DTK_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
