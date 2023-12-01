require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.193.0.tgz"
  sha256 "49b6d2a5170bde0532839df3be7d266793f0e464db95c5d12fa07bff066bbb8c"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8430f40c7bf5d693225e826afd7c81238ca7aeec88db9885ad28ddcb774f7b0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8430f40c7bf5d693225e826afd7c81238ca7aeec88db9885ad28ddcb774f7b0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8430f40c7bf5d693225e826afd7c81238ca7aeec88db9885ad28ddcb774f7b0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "22c7158f5cbfca3160bc31e7a73362fa76a3a84cc3cfc9ed13ae1b85339d8947"
    sha256 cellar: :any_skip_relocation, ventura:        "22c7158f5cbfca3160bc31e7a73362fa76a3a84cc3cfc9ed13ae1b85339d8947"
    sha256 cellar: :any_skip_relocation, monterey:       "22c7158f5cbfca3160bc31e7a73362fa76a3a84cc3cfc9ed13ae1b85339d8947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8430f40c7bf5d693225e826afd7c81238ca7aeec88db9885ad28ddcb774f7b0f"
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
