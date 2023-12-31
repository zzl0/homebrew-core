require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.23.tgz"
  sha256 "733cf1fd83b524517d5ad7ccdf977d542848760fb7e32c93641768fb1e58f45d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "615d41e9f7bff04ef3cef9f399d7f9eed28229342c3f5838ca42b19e5b37be40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "615d41e9f7bff04ef3cef9f399d7f9eed28229342c3f5838ca42b19e5b37be40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "615d41e9f7bff04ef3cef9f399d7f9eed28229342c3f5838ca42b19e5b37be40"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9ba4f638a686b272ea727cab2a925accd5a07de6ed75d020460b92390c09937"
    sha256 cellar: :any_skip_relocation, ventura:        "b9ba4f638a686b272ea727cab2a925accd5a07de6ed75d020460b92390c09937"
    sha256 cellar: :any_skip_relocation, monterey:       "b9ba4f638a686b272ea727cab2a925accd5a07de6ed75d020460b92390c09937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "615d41e9f7bff04ef3cef9f399d7f9eed28229342c3f5838ca42b19e5b37be40"
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
