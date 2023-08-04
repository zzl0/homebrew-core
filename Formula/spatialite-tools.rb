class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-5.0.1.tar.gz"
  sha256 "9604c205e87f037789bc52302c66ccd1371c3e98c74e8ec4e29b0752de35171c"
  license "GPL-3.0-or-later"
  revision 4

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/"
    regex(/href=.*?spatialite-tools[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1a931418bfbef5b64396031baebc4462a340a7d09c192915f14bf2bc4055de5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13bc1b2535b2c6e406f70918faf6ecd56afc3560d410eb3008a933ad60564635"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de9a15768ccca6354a320603babd68a185ce704cb5517df1867f3b9a5ddb2de2"
    sha256 cellar: :any_skip_relocation, ventura:        "744ba791b58397a07c550560358be2972dc57b1d6c285677f15344a15ec953ba"
    sha256 cellar: :any_skip_relocation, monterey:       "7d92709e9eb0f828586a531c3aca5946c138b0adfb3a07a1e9386554f5be1e14"
    sha256 cellar: :any_skip_relocation, big_sur:        "93763f63f9fe08eb4a707fb227e8e405fd75482da16cd4c07d71c86b41e94eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f792e592db95f0d8b725808d24b57618c73ca9b8cd98eb5b31194d244b0c5dde"
  end

  depends_on "pkg-config" => :build
  depends_on "libspatialite"
  depends_on "proj"
  depends_on "readosm"

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    # Ensure Homebrew SQLite is found before system SQLite.
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"spatialite", "--version"
  end
end
