require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.197.0.tgz"
  sha256 "030a4997dcc1dfc2ecfddbe19249e4a3e2d44df2467174ae14defebfbc736bda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bac0635180899ba9efb6684627ca28724e74087ad36ebe3ece29bfd11824ccd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bac0635180899ba9efb6684627ca28724e74087ad36ebe3ece29bfd11824ccd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bac0635180899ba9efb6684627ca28724e74087ad36ebe3ece29bfd11824ccd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "082fb9933c02bc37db58a6b0a5e12364be35194c1d5158d62ae60acadf1d9adf"
    sha256 cellar: :any_skip_relocation, ventura:        "082fb9933c02bc37db58a6b0a5e12364be35194c1d5158d62ae60acadf1d9adf"
    sha256 cellar: :any_skip_relocation, monterey:       "082fb9933c02bc37db58a6b0a5e12364be35194c1d5158d62ae60acadf1d9adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bac0635180899ba9efb6684627ca28724e74087ad36ebe3ece29bfd11824ccd2"
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
