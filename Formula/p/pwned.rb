require "language/node"

class Pwned < Formula
  desc "CLI for the 'Have I been pwned?' service"
  homepage "https://github.com/wKovacs64/pwned"
  url "https://registry.npmjs.org/pwned/-/pwned-12.1.0.tgz"
  sha256 "c4a85db863372c340d7c6e7bfa1d37213a0b971d1ac1b4f9e1af5b0a219f4a8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd58e47c4bad812220be627a01bb6257eab376eeb2150ffd1c0b1a1620efc41d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pwned --version")

    assert_match "Oh no — pwned", shell_output("#{bin}/pwned pw homebrew 2>&1")
  end
end
