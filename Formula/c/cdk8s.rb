require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.8.tgz"
  sha256 "367ca4ea975dc0bc4985dda24f8d2a71561fb0b9077ca7941e168c79d0908ba2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d494ab4f21dad5b4f5fd44cb2e26b7032087afdadc536400bb0d42fd419fa86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d494ab4f21dad5b4f5fd44cb2e26b7032087afdadc536400bb0d42fd419fa86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d494ab4f21dad5b4f5fd44cb2e26b7032087afdadc536400bb0d42fd419fa86"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bb06829041cd59e9df2f74edc9c408fd98079dfa67132c56a2cfd1dbc54ffa5"
    sha256 cellar: :any_skip_relocation, ventura:        "2bb06829041cd59e9df2f74edc9c408fd98079dfa67132c56a2cfd1dbc54ffa5"
    sha256 cellar: :any_skip_relocation, monterey:       "2bb06829041cd59e9df2f74edc9c408fd98079dfa67132c56a2cfd1dbc54ffa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d494ab4f21dad5b4f5fd44cb2e26b7032087afdadc536400bb0d42fd419fa86"
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
