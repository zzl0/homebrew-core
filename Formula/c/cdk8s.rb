require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.145.0.tgz"
  sha256 "b52341f2aee0640960a27ba6150d80c46a3828ce749f720fed9225caeaea4633"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37d34d24686fd53f2f6d2e90a6960c8b21ecc0dbdcf98b4993044e0ac92acaf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37d34d24686fd53f2f6d2e90a6960c8b21ecc0dbdcf98b4993044e0ac92acaf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37d34d24686fd53f2f6d2e90a6960c8b21ecc0dbdcf98b4993044e0ac92acaf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fed8219a854308435ca680f29a02377ba523f90cc0c367ee4d2e1da61ac1fee"
    sha256 cellar: :any_skip_relocation, ventura:        "0fed8219a854308435ca680f29a02377ba523f90cc0c367ee4d2e1da61ac1fee"
    sha256 cellar: :any_skip_relocation, monterey:       "0fed8219a854308435ca680f29a02377ba523f90cc0c367ee4d2e1da61ac1fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d34d24686fd53f2f6d2e90a6960c8b21ecc0dbdcf98b4993044e0ac92acaf2"
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
