require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.174.0.tgz"
  sha256 "5ca061a040550abf56c8da9840c4258cc8ff19e4da393d41032510f23eb4db83"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c8832fb885e8d3949d35c82045e3fb8341923e9f1498813a79d2241acb3bada"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c8832fb885e8d3949d35c82045e3fb8341923e9f1498813a79d2241acb3bada"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c8832fb885e8d3949d35c82045e3fb8341923e9f1498813a79d2241acb3bada"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4b5b6070aa8e3f1cf3a3ef340108bf9234f8f30e341fe66fe92fb3b259188de"
    sha256 cellar: :any_skip_relocation, ventura:        "f4b5b6070aa8e3f1cf3a3ef340108bf9234f8f30e341fe66fe92fb3b259188de"
    sha256 cellar: :any_skip_relocation, monterey:       "f4b5b6070aa8e3f1cf3a3ef340108bf9234f8f30e341fe66fe92fb3b259188de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c8832fb885e8d3949d35c82045e3fb8341923e9f1498813a79d2241acb3bada"
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
