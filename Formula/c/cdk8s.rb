require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.39.0.tgz"
  sha256 "fa11a9de7c3a2e6d829724bacb8ded946efa46ebf6fc167c45cb18b148e4415e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7055b7ebbb47c5e29857c4b9c52d7a1fdd207e0dcdbf122f31162b79430c3800"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7055b7ebbb47c5e29857c4b9c52d7a1fdd207e0dcdbf122f31162b79430c3800"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7055b7ebbb47c5e29857c4b9c52d7a1fdd207e0dcdbf122f31162b79430c3800"
    sha256 cellar: :any_skip_relocation, ventura:        "a185127f7294c0eda01835d2178d2808fc8d53997945ed511ab5f28c81758a75"
    sha256 cellar: :any_skip_relocation, monterey:       "a185127f7294c0eda01835d2178d2808fc8d53997945ed511ab5f28c81758a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "a185127f7294c0eda01835d2178d2808fc8d53997945ed511ab5f28c81758a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7055b7ebbb47c5e29857c4b9c52d7a1fdd207e0dcdbf122f31162b79430c3800"
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
