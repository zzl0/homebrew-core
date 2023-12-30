class Halp < Formula
  desc "CLI tool to get help with CLI tools"
  homepage "https://halp.cli.rs/"
  url "https://github.com/orhun/halp/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "ec074ceb472c4a85dbd321ef3928014d6ac2e60a23f2ef8055e3133ecd845b88"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/orhun/halp.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Setup OUT_DIR for completion and manpage generations
    ENV["OUT_DIR"] = buildpath

    system bin/"halp-completions"
    bash_completion.install "halp.bash" => "halp"
    fish_completion.install "halp.fish"
    zsh_completion.install "_halp"

    system bin/"halp-mangen"
    man1.install "halp.1"

    # Remove binaries used for building completions and manpage
    rm_f [bin/"halp-completions", bin/"halp-mangen", bin/"halp-test"]
  end

  test do
    output = shell_output("#{bin}/halp halp")
    assert_match <<~EOS, output
      (\u00B0\u30ED\u00B0)  checking 'halp -v'
      (\u00D7\uFE4F\u00D7)      fail '-v' argument not found.
      (\u00B0\u30ED\u00B0)  checking 'halp -V'
      \\(^\u30EE^)/ success '-V' argument found!
    EOS

    assert_match version.to_s, shell_output("#{bin}/halp --version")
  end
end
