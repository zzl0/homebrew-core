require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.102.0.tgz"
  sha256 "33ebef61cb94d436f887367a2f8886f0cd4c010be1adbbf395b59610c2708857"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac6523cc726a63ec0dae6c8eac27f48f711c7ff1a4a8e6e43e3c7fc7ac210a2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac6523cc726a63ec0dae6c8eac27f48f711c7ff1a4a8e6e43e3c7fc7ac210a2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac6523cc726a63ec0dae6c8eac27f48f711c7ff1a4a8e6e43e3c7fc7ac210a2f"
    sha256 cellar: :any_skip_relocation, ventura:        "d495f5dde0c718dfeeaedc58f4fd171fb4db6d061224ba9d1c0051b363c226ed"
    sha256 cellar: :any_skip_relocation, monterey:       "d495f5dde0c718dfeeaedc58f4fd171fb4db6d061224ba9d1c0051b363c226ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "d495f5dde0c718dfeeaedc58f4fd171fb4db6d061224ba9d1c0051b363c226ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac6523cc726a63ec0dae6c8eac27f48f711c7ff1a4a8e6e43e3c7fc7ac210a2f"
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
