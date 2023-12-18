require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.13.tgz"
  sha256 "bb347e60147db1aebf831b4f7bec61243bf312579de087a340ab6ddca350aadf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f65d3316d3ee295ea444e6484e57e576d30b57da6b796305747065b3dc34f4d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f65d3316d3ee295ea444e6484e57e576d30b57da6b796305747065b3dc34f4d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f65d3316d3ee295ea444e6484e57e576d30b57da6b796305747065b3dc34f4d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d26c726ad76833c4405effb6cc5d9f02fd1510de54af320e25ff616bd39b736"
    sha256 cellar: :any_skip_relocation, ventura:        "5d26c726ad76833c4405effb6cc5d9f02fd1510de54af320e25ff616bd39b736"
    sha256 cellar: :any_skip_relocation, monterey:       "5d26c726ad76833c4405effb6cc5d9f02fd1510de54af320e25ff616bd39b736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f65d3316d3ee295ea444e6484e57e576d30b57da6b796305747065b3dc34f4d1"
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
