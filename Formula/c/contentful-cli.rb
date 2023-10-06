require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.27.tgz"
  sha256 "0b7562e9f887bfea5ca5ef8a056c436aa4b4e6ba50a4e4f73d0cdd01dc97e00e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1447207feb122513c0df035a5f872361a0a184694705273094fc69362645256"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1447207feb122513c0df035a5f872361a0a184694705273094fc69362645256"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1447207feb122513c0df035a5f872361a0a184694705273094fc69362645256"
    sha256 cellar: :any_skip_relocation, sonoma:         "30eeb10dd5161641e72cc5821f86e34aaf5a62355685e9bc2d255721c2d70dcc"
    sha256 cellar: :any_skip_relocation, ventura:        "30eeb10dd5161641e72cc5821f86e34aaf5a62355685e9bc2d255721c2d70dcc"
    sha256 cellar: :any_skip_relocation, monterey:       "30eeb10dd5161641e72cc5821f86e34aaf5a62355685e9bc2d255721c2d70dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1447207feb122513c0df035a5f872361a0a184694705273094fc69362645256"
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
