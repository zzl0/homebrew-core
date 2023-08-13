class Czkawka < Formula
  desc "Duplicate file utility"
  homepage "https://github.com/qarmin/czkawka"
  url "https://github.com/qarmin/czkawka/archive/refs/tags/6.0.0.tar.gz"
  sha256 "32dc1d8a55bc3ce478246830a1f81679affa85735e69aa049fd83e30271e368f"
  license all_of: ["MIT", "CC-BY-4.0"]

  depends_on "rust" => :build
  depends_on "adwaita-icon-theme"
  depends_on "ffmpeg"
  depends_on "gtk4"
  depends_on "libheif"
  depends_on "librsvg"
  depends_on "pkg-config"
  depends_on "webp-pixbuf-loader"

  def install
    system "cargo", "install", *std_cargo_args(path: "czkawka_cli")
    system "cargo", "install", *std_cargo_args(path: "czkawka_gui")
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
  end

  def caveats
    <<~EOS
      czkawka_gui requires $XDG_DATA_DIRS to contain "#{HOMEBREW_PREFIX}/share".
    EOS
  end

  test do
    assert_match "Found 0 duplicated files in 0 groups",
    shell_output("#{bin}/czkawka_cli dup --directories #{testpath}")
  end
end
