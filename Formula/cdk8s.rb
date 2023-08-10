require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.29.0.tgz"
  sha256 "4a3e529edf70cb31a12d1e897b0ac6d5f3f5623affbb7ed680d3bc9d5ba93441"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "984ffda181ba212bcea3328f1f939ab4bd1874cd1d0507bf7e3a0e037fc9f492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "984ffda181ba212bcea3328f1f939ab4bd1874cd1d0507bf7e3a0e037fc9f492"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "984ffda181ba212bcea3328f1f939ab4bd1874cd1d0507bf7e3a0e037fc9f492"
    sha256 cellar: :any_skip_relocation, ventura:        "b108fb0530c797a5355074dff3df56e762665d7dd2bbf85a4e8b8c8e55c61296"
    sha256 cellar: :any_skip_relocation, monterey:       "b108fb0530c797a5355074dff3df56e762665d7dd2bbf85a4e8b8c8e55c61296"
    sha256 cellar: :any_skip_relocation, big_sur:        "b108fb0530c797a5355074dff3df56e762665d7dd2bbf85a4e8b8c8e55c61296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "984ffda181ba212bcea3328f1f939ab4bd1874cd1d0507bf7e3a0e037fc9f492"
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
