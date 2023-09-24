require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.101.0.tgz"
  sha256 "c4d148c124292cf0a04b426071acb4810bff639a09579eee1547900a3d82da6e"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63c06686951494af3974d962fe5ef59251bcac652d2f162996398f8c5c482b5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63c06686951494af3974d962fe5ef59251bcac652d2f162996398f8c5c482b5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63c06686951494af3974d962fe5ef59251bcac652d2f162996398f8c5c482b5f"
    sha256 cellar: :any_skip_relocation, ventura:        "240d89e9b553560d0eb2eef5a44619e74eee18c7d31f293140ad8e7b37541c12"
    sha256 cellar: :any_skip_relocation, monterey:       "240d89e9b553560d0eb2eef5a44619e74eee18c7d31f293140ad8e7b37541c12"
    sha256 cellar: :any_skip_relocation, big_sur:        "240d89e9b553560d0eb2eef5a44619e74eee18c7d31f293140ad8e7b37541c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63c06686951494af3974d962fe5ef59251bcac652d2f162996398f8c5c482b5f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
