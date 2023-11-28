class Solo2Cli < Formula
  desc "CLI to update and use Solo 2 security keys"
  homepage "https://solokeys.com/"
  url "https://github.com/solokeys/solo2-cli/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "49a30c5ee6f38be968a520089741f8b936099611e98e6bf2b25d05e5e9335fb4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/solokeys/solo2-cli.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
    depends_on "systemd"
  end

  def install
    system "cargo", "install", "--all-features", *std_cargo_args

    bash_completion.install "target/release/solo2.bash"
    fish_completion.install "target/release/solo2.fish"
    zsh_completion.install "target/release/_solo2"
  end

  test do
    assert_empty shell_output("#{bin}/solo2 ls")
    assert_match version.to_s, shell_output("#{bin}/solo2 --version")
  end
end
