require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.122.0.tgz"
  sha256 "5eb67b4b2ed4f1586e2883cf70e83eb2a61f6e9837a561acd6213a6a3e071bc6"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "977b0aa95cc4b082fbc06ecdd92a3e97d721d4f9bc00cc1e7cdc2c94b2fcc6d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "977b0aa95cc4b082fbc06ecdd92a3e97d721d4f9bc00cc1e7cdc2c94b2fcc6d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "977b0aa95cc4b082fbc06ecdd92a3e97d721d4f9bc00cc1e7cdc2c94b2fcc6d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6da226353cbebc5431b4c8a2606033a32bf10228b8de5436c50ba553fbabdb8d"
    sha256 cellar: :any_skip_relocation, ventura:        "6da226353cbebc5431b4c8a2606033a32bf10228b8de5436c50ba553fbabdb8d"
    sha256 cellar: :any_skip_relocation, monterey:       "6da226353cbebc5431b4c8a2606033a32bf10228b8de5436c50ba553fbabdb8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "977b0aa95cc4b082fbc06ecdd92a3e97d721d4f9bc00cc1e7cdc2c94b2fcc6d8"
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
