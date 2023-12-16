require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.11.tgz"
  sha256 "07a66785dedfb74cb0d6b6488772a1499b9549328e39ea5ff44acd8f4160bb8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8c21f61e73cea234573c514e6bf619ec4c10c62fa620db827f30e3595264682"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8c21f61e73cea234573c514e6bf619ec4c10c62fa620db827f30e3595264682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8c21f61e73cea234573c514e6bf619ec4c10c62fa620db827f30e3595264682"
    sha256 cellar: :any_skip_relocation, sonoma:         "feb52b62c7c7d4463f141d26ad96ebaf60abe23acbc8a571c94d1ac6fbea4a7a"
    sha256 cellar: :any_skip_relocation, ventura:        "feb52b62c7c7d4463f141d26ad96ebaf60abe23acbc8a571c94d1ac6fbea4a7a"
    sha256 cellar: :any_skip_relocation, monterey:       "feb52b62c7c7d4463f141d26ad96ebaf60abe23acbc8a571c94d1ac6fbea4a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8c21f61e73cea234573c514e6bf619ec4c10c62fa620db827f30e3595264682"
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
