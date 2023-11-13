require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.175.0.tgz"
  sha256 "0deb932b7fef93a63f3dddce63bbb2a61f04bded8d0ae685a3a299284e30b9d5"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3423963544c287ef9883eb99ef071a945d6432e04b81e944eaffc8d696703b76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3423963544c287ef9883eb99ef071a945d6432e04b81e944eaffc8d696703b76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3423963544c287ef9883eb99ef071a945d6432e04b81e944eaffc8d696703b76"
    sha256 cellar: :any_skip_relocation, sonoma:         "82f01a4c96892f54ce94312d8de2c39170ddde3c19e31b2403182d8eefa5b85b"
    sha256 cellar: :any_skip_relocation, ventura:        "82f01a4c96892f54ce94312d8de2c39170ddde3c19e31b2403182d8eefa5b85b"
    sha256 cellar: :any_skip_relocation, monterey:       "82f01a4c96892f54ce94312d8de2c39170ddde3c19e31b2403182d8eefa5b85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3423963544c287ef9883eb99ef071a945d6432e04b81e944eaffc8d696703b76"
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
