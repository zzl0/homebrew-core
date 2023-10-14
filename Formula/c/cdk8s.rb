require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.140.0.tgz"
  sha256 "f89d55c356710ba7d55856c839ba2ba5b892ffef393bdd864d083018aaf6cce4"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f527eee0bdf31bc896a9cf197a9724b1f807088b784ad27982e7b00216d09adb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f527eee0bdf31bc896a9cf197a9724b1f807088b784ad27982e7b00216d09adb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f527eee0bdf31bc896a9cf197a9724b1f807088b784ad27982e7b00216d09adb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5fbb8fd31a890a1366a041f9d55f27c6b5a7565ce43a098cada9cccfc2567c4"
    sha256 cellar: :any_skip_relocation, ventura:        "f5fbb8fd31a890a1366a041f9d55f27c6b5a7565ce43a098cada9cccfc2567c4"
    sha256 cellar: :any_skip_relocation, monterey:       "f5fbb8fd31a890a1366a041f9d55f27c6b5a7565ce43a098cada9cccfc2567c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f527eee0bdf31bc896a9cf197a9724b1f807088b784ad27982e7b00216d09adb"
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
