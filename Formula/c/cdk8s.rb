require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.190.0.tgz"
  sha256 "bd1007a1de8d2fb26c9831bac7bfdac6875569b4fea27cc57cbb975a861d2a66"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9746e08ca9a06691e28616b939d27abfaee7e221336c6b994cbe32fb0e326045"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9746e08ca9a06691e28616b939d27abfaee7e221336c6b994cbe32fb0e326045"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9746e08ca9a06691e28616b939d27abfaee7e221336c6b994cbe32fb0e326045"
    sha256 cellar: :any_skip_relocation, sonoma:         "2db28e93db451d308bc535c233dbdf86fd53d88e8f0d8911d9ae45e2e09af74a"
    sha256 cellar: :any_skip_relocation, ventura:        "2db28e93db451d308bc535c233dbdf86fd53d88e8f0d8911d9ae45e2e09af74a"
    sha256 cellar: :any_skip_relocation, monterey:       "2db28e93db451d308bc535c233dbdf86fd53d88e8f0d8911d9ae45e2e09af74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9746e08ca9a06691e28616b939d27abfaee7e221336c6b994cbe32fb0e326045"
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
