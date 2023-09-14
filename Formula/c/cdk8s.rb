require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.87.0.tgz"
  sha256 "63f085ef2de3b34044b98f6fc2cdd11c0579699a29b0f460d03f25486122b218"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fec02bb6b4d425fb4f3fb7b9c25691b67c3848a872c125e5f11978cff361515c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fec02bb6b4d425fb4f3fb7b9c25691b67c3848a872c125e5f11978cff361515c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fec02bb6b4d425fb4f3fb7b9c25691b67c3848a872c125e5f11978cff361515c"
    sha256 cellar: :any_skip_relocation, ventura:        "175fe057a3a9a7d4f1329a0dce02ad08b34618109c82236798dcf15f5dd5ba2c"
    sha256 cellar: :any_skip_relocation, monterey:       "175fe057a3a9a7d4f1329a0dce02ad08b34618109c82236798dcf15f5dd5ba2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "175fe057a3a9a7d4f1329a0dce02ad08b34618109c82236798dcf15f5dd5ba2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fec02bb6b4d425fb4f3fb7b9c25691b67c3848a872c125e5f11978cff361515c"
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
