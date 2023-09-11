require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.82.0.tgz"
  sha256 "0a4bbe3df69db908f8b258c355e1c5d0e5c41dea3e276c7ea7cd16541e8911a8"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01c11397ead86045205583d3c3828ec2619b4d8e4480bbb46cb142144d172d4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01c11397ead86045205583d3c3828ec2619b4d8e4480bbb46cb142144d172d4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01c11397ead86045205583d3c3828ec2619b4d8e4480bbb46cb142144d172d4b"
    sha256 cellar: :any_skip_relocation, ventura:        "18b020ef6bc662ac3dde207d432339d67b8d15e742d017419fc2ebf4b1250c2b"
    sha256 cellar: :any_skip_relocation, monterey:       "18b020ef6bc662ac3dde207d432339d67b8d15e742d017419fc2ebf4b1250c2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "18b020ef6bc662ac3dde207d432339d67b8d15e742d017419fc2ebf4b1250c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01c11397ead86045205583d3c3828ec2619b4d8e4480bbb46cb142144d172d4b"
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
