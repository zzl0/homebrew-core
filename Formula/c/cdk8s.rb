require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.122.0.tgz"
  sha256 "5eb67b4b2ed4f1586e2883cf70e83eb2a61f6e9837a561acd6213a6a3e071bc6"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb9f7ccdd1e20bb829d3647593517fcfa0a6d9e63a1d9599c86c9d31c919b3b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb9f7ccdd1e20bb829d3647593517fcfa0a6d9e63a1d9599c86c9d31c919b3b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb9f7ccdd1e20bb829d3647593517fcfa0a6d9e63a1d9599c86c9d31c919b3b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "27a25bdb3a82d3873103212e337b246a0249084a6c381c98497a417dd1f4ba0e"
    sha256 cellar: :any_skip_relocation, ventura:        "27a25bdb3a82d3873103212e337b246a0249084a6c381c98497a417dd1f4ba0e"
    sha256 cellar: :any_skip_relocation, monterey:       "27a25bdb3a82d3873103212e337b246a0249084a6c381c98497a417dd1f4ba0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb9f7ccdd1e20bb829d3647593517fcfa0a6d9e63a1d9599c86c9d31c919b3b8"
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
