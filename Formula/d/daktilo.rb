class Daktilo < Formula
  desc "Plays typewriter sounds every time you press a key"
  homepage "https://daktilo.cli.rs"
  url "https://github.com/orhun/daktilo/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "55aead933dfe9176bc6f55f397bfe05f5eb97ef0f2b06e6904e4227f3e715b70"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxi"
    depends_on "libxtst"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/daktilo --version")

    output = shell_output("#{bin}/daktilo -l")
    assert_match "kick.mp3,hat.mp3,snare.mp3,kick.mp3,hat.mp3,kick.mp3,snare.mp3,hat.mp3", output
  end
end
