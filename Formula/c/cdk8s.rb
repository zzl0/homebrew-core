require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.189.0.tgz"
  sha256 "656ea26b7c984fa1a48bc1e63c7eb28b5eaab226a53507a0b3c32af22fa6680e"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0bea596bcc22c34791a350271a0cf38955114ee30d82644f55a2546b91b5e1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0bea596bcc22c34791a350271a0cf38955114ee30d82644f55a2546b91b5e1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0bea596bcc22c34791a350271a0cf38955114ee30d82644f55a2546b91b5e1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "16827a2f87629519323e444769f1645cc2e39557656178bd88a8676e40865af6"
    sha256 cellar: :any_skip_relocation, ventura:        "16827a2f87629519323e444769f1645cc2e39557656178bd88a8676e40865af6"
    sha256 cellar: :any_skip_relocation, monterey:       "16827a2f87629519323e444769f1645cc2e39557656178bd88a8676e40865af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0bea596bcc22c34791a350271a0cf38955114ee30d82644f55a2546b91b5e1a"
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
