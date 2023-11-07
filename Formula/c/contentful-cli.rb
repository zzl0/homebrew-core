require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.11.tgz"
  sha256 "2dd8bdd699246c506dccd36c4739ea2a90da647efaeca1346fe9d5d25bfe87b5"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09e2fb9ae9db85db0877e86f407f5295f583dbdddb44d9181bc18ce3daf4f598"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09e2fb9ae9db85db0877e86f407f5295f583dbdddb44d9181bc18ce3daf4f598"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09e2fb9ae9db85db0877e86f407f5295f583dbdddb44d9181bc18ce3daf4f598"
    sha256 cellar: :any_skip_relocation, sonoma:         "65e515e8e01ecfbb9e434c46b09f515ab0bd65ee2c86cb4f76b086054bc38e42"
    sha256 cellar: :any_skip_relocation, ventura:        "65e515e8e01ecfbb9e434c46b09f515ab0bd65ee2c86cb4f76b086054bc38e42"
    sha256 cellar: :any_skip_relocation, monterey:       "65e515e8e01ecfbb9e434c46b09f515ab0bd65ee2c86cb4f76b086054bc38e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09e2fb9ae9db85db0877e86f407f5295f583dbdddb44d9181bc18ce3daf4f598"
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
