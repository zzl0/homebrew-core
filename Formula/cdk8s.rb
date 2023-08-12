require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.34.0.tgz"
  sha256 "888d270845b6410a67b4550cf7ce2cc1d889e8131e9db02b7ed5826fed2d330b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3ecbec471722ab41ef6e48e4ae1199e0360a542fea71ad255ea8059a0479068"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3ecbec471722ab41ef6e48e4ae1199e0360a542fea71ad255ea8059a0479068"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3ecbec471722ab41ef6e48e4ae1199e0360a542fea71ad255ea8059a0479068"
    sha256 cellar: :any_skip_relocation, ventura:        "3f7792e9ad2c8111cbc60048ffbefc8c4cc2f392761eb0a417f44bc7fc0488e9"
    sha256 cellar: :any_skip_relocation, monterey:       "3f7792e9ad2c8111cbc60048ffbefc8c4cc2f392761eb0a417f44bc7fc0488e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f7792e9ad2c8111cbc60048ffbefc8c4cc2f392761eb0a417f44bc7fc0488e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3ecbec471722ab41ef6e48e4ae1199e0360a542fea71ad255ea8059a0479068"
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
