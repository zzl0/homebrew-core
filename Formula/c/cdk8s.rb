require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.59.0.tgz"
  sha256 "592a64bb8097fb7a6b609afeea9ef45c153b5b411da2e94059e89d18ed076f2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f2a783ca5a0f4e8aeb4489fdd4bb0c0f503cf4c99cb6563a2f9c2fed88bd2f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f2a783ca5a0f4e8aeb4489fdd4bb0c0f503cf4c99cb6563a2f9c2fed88bd2f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f2a783ca5a0f4e8aeb4489fdd4bb0c0f503cf4c99cb6563a2f9c2fed88bd2f1"
    sha256 cellar: :any_skip_relocation, ventura:        "2edebf0bb79d47064f406e0ef3399afb4d72c53b47b7274b3101c4336f39fae9"
    sha256 cellar: :any_skip_relocation, monterey:       "2edebf0bb79d47064f406e0ef3399afb4d72c53b47b7274b3101c4336f39fae9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2edebf0bb79d47064f406e0ef3399afb4d72c53b47b7274b3101c4336f39fae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2a783ca5a0f4e8aeb4489fdd4bb0c0f503cf4c99cb6563a2f9c2fed88bd2f1"
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
