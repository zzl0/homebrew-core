require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.116.0.tgz"
  sha256 "f50e5111ef8a9482f4871d08f532c7a743482acc7957ce521bc958c72a4ed64f"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c939d19f6e3e4943d778a8f9e3d2b0ac050a00007708a02d0a39fc587d5c347"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c939d19f6e3e4943d778a8f9e3d2b0ac050a00007708a02d0a39fc587d5c347"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c939d19f6e3e4943d778a8f9e3d2b0ac050a00007708a02d0a39fc587d5c347"
    sha256 cellar: :any_skip_relocation, sonoma:         "994df6817894067c0546b99f1cc23a646b95e4f773a512052dae64cb1d1bbe93"
    sha256 cellar: :any_skip_relocation, ventura:        "994df6817894067c0546b99f1cc23a646b95e4f773a512052dae64cb1d1bbe93"
    sha256 cellar: :any_skip_relocation, monterey:       "994df6817894067c0546b99f1cc23a646b95e4f773a512052dae64cb1d1bbe93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c939d19f6e3e4943d778a8f9e3d2b0ac050a00007708a02d0a39fc587d5c347"
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
