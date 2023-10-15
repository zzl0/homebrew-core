require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.141.0.tgz"
  sha256 "0fa2d9d228f16658bd905be150100872da386619189a14459fb5e68ad577bd1e"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51f57ff6d68ce107bf26aa04eb96ed1a6042fb2aa82d3591d1ac55a306e110d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51f57ff6d68ce107bf26aa04eb96ed1a6042fb2aa82d3591d1ac55a306e110d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51f57ff6d68ce107bf26aa04eb96ed1a6042fb2aa82d3591d1ac55a306e110d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "26f3bc349b2b6fb5de23fc67f4519acae13ff9009b2b580ef81775c7179ab4c9"
    sha256 cellar: :any_skip_relocation, ventura:        "26f3bc349b2b6fb5de23fc67f4519acae13ff9009b2b580ef81775c7179ab4c9"
    sha256 cellar: :any_skip_relocation, monterey:       "26f3bc349b2b6fb5de23fc67f4519acae13ff9009b2b580ef81775c7179ab4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51f57ff6d68ce107bf26aa04eb96ed1a6042fb2aa82d3591d1ac55a306e110d6"
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
