require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.162.0.tgz"
  sha256 "8299fe36f22040b43b3c4d99689a2db99339dde99db0be7a6c626d9d9acdf652"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c421137eceacee05136487aa3ba498850c077bba45188d4331dec2ffca857969"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c421137eceacee05136487aa3ba498850c077bba45188d4331dec2ffca857969"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c421137eceacee05136487aa3ba498850c077bba45188d4331dec2ffca857969"
    sha256 cellar: :any_skip_relocation, sonoma:         "45206c963ea7694b91110a7ae72713b5de4e6bc426f2195bd6fdb1dfb82c3c38"
    sha256 cellar: :any_skip_relocation, ventura:        "45206c963ea7694b91110a7ae72713b5de4e6bc426f2195bd6fdb1dfb82c3c38"
    sha256 cellar: :any_skip_relocation, monterey:       "45206c963ea7694b91110a7ae72713b5de4e6bc426f2195bd6fdb1dfb82c3c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c421137eceacee05136487aa3ba498850c077bba45188d4331dec2ffca857969"
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
