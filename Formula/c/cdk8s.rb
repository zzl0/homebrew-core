require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.43.0.tgz"
  sha256 "9668e206b29896f21d8bc37aef280c7b7a3b8e8152fba663f9d722f531c0848e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0e920863f5e23b6616fc36a55a74d747d2b7ac1552b47b163d2b296efd338af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0e920863f5e23b6616fc36a55a74d747d2b7ac1552b47b163d2b296efd338af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0e920863f5e23b6616fc36a55a74d747d2b7ac1552b47b163d2b296efd338af"
    sha256 cellar: :any_skip_relocation, ventura:        "ec7c0cb1e6911052b833e88e55dd13f6c75ba8c6ff693c8fb077ad723cf0ac09"
    sha256 cellar: :any_skip_relocation, monterey:       "ec7c0cb1e6911052b833e88e55dd13f6c75ba8c6ff693c8fb077ad723cf0ac09"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec7c0cb1e6911052b833e88e55dd13f6c75ba8c6ff693c8fb077ad723cf0ac09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0e920863f5e23b6616fc36a55a74d747d2b7ac1552b47b163d2b296efd338af"
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
