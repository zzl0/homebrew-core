require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.171.0.tgz"
  sha256 "c3a6be2e317cc77579328acd4cbc79e2d7c4884c1830e1f85b0f348404613794"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6a1ce2b9d0dd524432b3318d39d56b6b9565b46b89c7bf6605e465ac9818a5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6a1ce2b9d0dd524432b3318d39d56b6b9565b46b89c7bf6605e465ac9818a5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6a1ce2b9d0dd524432b3318d39d56b6b9565b46b89c7bf6605e465ac9818a5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5b5c87819da0eef38826817902c21d9b054279d2f17b5ee7af395d1012b89d1"
    sha256 cellar: :any_skip_relocation, ventura:        "d5b5c87819da0eef38826817902c21d9b054279d2f17b5ee7af395d1012b89d1"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b5c87819da0eef38826817902c21d9b054279d2f17b5ee7af395d1012b89d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6a1ce2b9d0dd524432b3318d39d56b6b9565b46b89c7bf6605e465ac9818a5a"
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
