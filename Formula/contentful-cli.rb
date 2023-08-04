require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.35.tgz"
  sha256 "67188549e20051a95a3e5376a79b1ac00b0b915981fb91aeca832140c564e824"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dd0518d450ced476fb3c99968e9e177b1b57867231969f778379ae0040efaa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dd0518d450ced476fb3c99968e9e177b1b57867231969f778379ae0040efaa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dd0518d450ced476fb3c99968e9e177b1b57867231969f778379ae0040efaa8"
    sha256 cellar: :any_skip_relocation, ventura:        "f5d6df4d2bfda66dc932cc073164a5adfa48f2e2597994f56971058c3d79ae4c"
    sha256 cellar: :any_skip_relocation, monterey:       "f5d6df4d2bfda66dc932cc073164a5adfa48f2e2597994f56971058c3d79ae4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5d6df4d2bfda66dc932cc073164a5adfa48f2e2597994f56971058c3d79ae4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dd0518d450ced476fb3c99968e9e177b1b57867231969f778379ae0040efaa8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
