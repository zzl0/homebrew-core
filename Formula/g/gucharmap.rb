class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.1.0/gucharmap-15.1.0.tar.bz2"
  sha256 "8d9b4a5fb2179dcd483490a4fca567aec23b9ee96d0bc39b3fe73a3152feab00"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "a6cc905bd8f7b030c33669b2206a936d5eea7624cda347287c2d4d45d5ebea64"
    sha256 arm64_monterey: "3a4d12ca000be73e94d1d4cbc9dbf9934b9bac407155c96fe8173c17bbf0c1ec"
    sha256 arm64_big_sur:  "2de5a4f0c034ec5d64e835929f81e59ee31c3e01a581e1af77af65845a34cb45"
    sha256 ventura:        "62695da2e8b3d1ed14603b8a9640a41b4333eeca9bf4177b3e8b8aa891227920"
    sha256 monterey:       "a5fc53ec7eacc87a6d69ea056bf8acf5aa7d4a52641856cf8f221fcebb3941b7"
    sha256 big_sur:        "5f9512394695d02e16c205c1a3cf6978cc3ba5eab059d5a8e0118945868ad778"
    sha256 x86_64_linux:   "75c0ad1e82e0a479397f49067c1a4835657642271c1af38e31808c431205df89"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "ucd" do
    url "https://www.unicode.org/Public/15.1.0/ucd/UCD.zip"
    sha256 "cb1c663d053926500cd501229736045752713a066bd75802098598b7a7056177"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/15.1.0/ucd/Unihan.zip", using: :nounzip
    sha256 "a0226610e324bcf784ac380e11f4cbf533ee1e6b3d028b0991bf8c0dc3f85853"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    (buildpath/"unicode").install resource("ucd")
    (buildpath/"unicode").install resource("unihan")

    # ERROR: Assert failed: -Wl,-Bsymbolic-functions is required but not supported
    inreplace "meson.build", "'-Wl,-Bsymbolic-functions'", "" if OS.mac?

    system "meson", *std_meson_args, "build", "-Ducd_path=#{buildpath}/unicode"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
