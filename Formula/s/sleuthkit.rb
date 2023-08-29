class Sleuthkit < Formula
  desc "Forensic toolkit"
  homepage "https://www.sleuthkit.org/"
  url "https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.12.1/sleuthkit-4.12.1.tar.gz"
  sha256 "6b2de0baabc6a38429a33993114ca3820329b477d5038cbf45fcf69fca8addfd"
  license all_of: ["IPL-1.0", "CPL-1.0", "GPL-2.0-or-later"]

  livecheck do
    url :stable
    regex(/sleuthkit[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f6709199beef626852ef259609f15a9192982675de5c76c356cfc0f33ea7c015"
    sha256 cellar: :any,                 arm64_monterey: "5ffcd207bad6e4fce580d3e13a5ecc6f85c544dc6d5247a4cb3ca170091c16fd"
    sha256 cellar: :any,                 arm64_big_sur:  "76496e3d4cb1c86a0d20bbb3dd80deb2d1aa9a6f994a783b95a851df729f97d3"
    sha256 cellar: :any,                 ventura:        "90820d426dd226299a6292c77caf086676390b65ec77f19c46cae85f99ad077d"
    sha256 cellar: :any,                 monterey:       "5495bb5167897236261065b3ab83a6ffbdf324c334fd16db52fecc3a53e6f6bd"
    sha256 cellar: :any,                 big_sur:        "1797dbb75fdbedf156f385d6110e36edd35a213923c33a12ef15bb99fd766866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eb98e1c3fe45a629a4daab34d14b3d1bc3a7e25ecb7d60bf2b588e2ee0c64ff"
  end

  depends_on "ant" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libpq"
  depends_on "openjdk"

  uses_from_macos "sqlite"

  conflicts_with "ffind", because: "both install a `ffind` executable"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    ENV["ANT_FOUND"] = Formula["ant"].opt_bin/"ant"
    ENV.append_to_cflags "-DNDEBUG"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"

    cd "bindings/java" do
      system "ant"

      inreplace ["Makefile", "jni/Makefile"], Superenv.shims_path/"ld", "ld" if OS.linux?
    end
    prefix.install "bindings"
  end

  test do
    system "#{bin}/tsk_loaddb", "-V"
  end
end
