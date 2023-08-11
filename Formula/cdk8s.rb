require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.32.0.tgz"
  sha256 "0371de2d5f7c1ca8b0ae18004bb7c00d35c39e64f4118835d79c7eea9eba2b53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c5902d14ba80b24c6c5b294236258f554b605d571db5b94187564d26fa74ddf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c5902d14ba80b24c6c5b294236258f554b605d571db5b94187564d26fa74ddf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c5902d14ba80b24c6c5b294236258f554b605d571db5b94187564d26fa74ddf"
    sha256 cellar: :any_skip_relocation, ventura:        "7b0eab1e06e46e6a29eef2412ae6e531ef87e6a0a646cda47425e5e379a4a7e6"
    sha256 cellar: :any_skip_relocation, monterey:       "7b0eab1e06e46e6a29eef2412ae6e531ef87e6a0a646cda47425e5e379a4a7e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b0eab1e06e46e6a29eef2412ae6e531ef87e6a0a646cda47425e5e379a4a7e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5902d14ba80b24c6c5b294236258f554b605d571db5b94187564d26fa74ddf"
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
