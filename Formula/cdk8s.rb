require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.30.1.tgz"
  sha256 "c7c2ecf416b47d6fba6eacf2912bcc618a1bfb2b66b7065198227de9ee737679"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84f8b2d3aeb3dbae4323b84221b0ce9adbbe9f01cc033ff942901310dfac1675"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84f8b2d3aeb3dbae4323b84221b0ce9adbbe9f01cc033ff942901310dfac1675"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84f8b2d3aeb3dbae4323b84221b0ce9adbbe9f01cc033ff942901310dfac1675"
    sha256 cellar: :any_skip_relocation, ventura:        "c1aa363b293c3d9acf52883bd3e0fb611ffb97c2148872f7df0527364b51db2d"
    sha256 cellar: :any_skip_relocation, monterey:       "c1aa363b293c3d9acf52883bd3e0fb611ffb97c2148872f7df0527364b51db2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1aa363b293c3d9acf52883bd3e0fb611ffb97c2148872f7df0527364b51db2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84f8b2d3aeb3dbae4323b84221b0ce9adbbe9f01cc033ff942901310dfac1675"
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
