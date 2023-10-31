class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https://github.com/tldr-pages/tlrc"
  url "https://github.com/tldr-pages/tlrc/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "418d8f66d77bb01917b673a7dd7a54d58c2f8f297c0c6af5168c8d8b21effafc"
  license "MIT"
  head "https://github.com/tldr-pages/tlrc.git", branch: "main"

  depends_on "rust" => :build

  def install
    ENV["COMPLETION_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    man1.install "tldr.1"

    bash_completion.install "tldr.bash" => "tldr"
    zsh_completion.install "_tldr"
    fish_completion.install "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
