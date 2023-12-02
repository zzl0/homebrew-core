require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.195.0.tgz"
  sha256 "d32de4c27cf78a29d0b7c06e8e3c5c22d360d45b95372219794147e32669bc4d"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46185f86a43e438eb1e50b3fe3dfcbdef521c29845ea972df14acbe1ea0e871a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46185f86a43e438eb1e50b3fe3dfcbdef521c29845ea972df14acbe1ea0e871a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46185f86a43e438eb1e50b3fe3dfcbdef521c29845ea972df14acbe1ea0e871a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e7fd7d86c2abd433b4b96e57a7a4c5413ae018df4bd18c7ac8d50b149dd04a6"
    sha256 cellar: :any_skip_relocation, ventura:        "7e7fd7d86c2abd433b4b96e57a7a4c5413ae018df4bd18c7ac8d50b149dd04a6"
    sha256 cellar: :any_skip_relocation, monterey:       "7e7fd7d86c2abd433b4b96e57a7a4c5413ae018df4bd18c7ac8d50b149dd04a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46185f86a43e438eb1e50b3fe3dfcbdef521c29845ea972df14acbe1ea0e871a"
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
