require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.121.0.tgz"
  sha256 "21700d2b040191c08aa185f3a5949083df175fc5084ab7ed450b079dfb555dae"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e8f27b509fddb3dff9b3a33f701167fa7c2364d7d0a4d59364a6172241de6a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e8f27b509fddb3dff9b3a33f701167fa7c2364d7d0a4d59364a6172241de6a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e8f27b509fddb3dff9b3a33f701167fa7c2364d7d0a4d59364a6172241de6a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7b89d80b6c198b4862ad7b8509e9e892e2f9a340d36883b3722f7a5a6f17114"
    sha256 cellar: :any_skip_relocation, ventura:        "c7b89d80b6c198b4862ad7b8509e9e892e2f9a340d36883b3722f7a5a6f17114"
    sha256 cellar: :any_skip_relocation, monterey:       "c7b89d80b6c198b4862ad7b8509e9e892e2f9a340d36883b3722f7a5a6f17114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8f27b509fddb3dff9b3a33f701167fa7c2364d7d0a4d59364a6172241de6a0"
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
