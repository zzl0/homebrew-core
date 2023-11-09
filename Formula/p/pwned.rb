require "language/node"

class Pwned < Formula
  desc "CLI for the 'Have I been pwned?' service"
  homepage "https://github.com/wKovacs64/pwned"
  url "https://registry.npmjs.org/pwned/-/pwned-12.0.0.tgz"
  sha256 "b4944b55836e95ae05984e3b1d8112d30500cac2b3a667d4567c4eb280e11418"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3920a5c684a3f16e8596a419884b7152f0ff59ea179c784e69871683adf43081"
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
