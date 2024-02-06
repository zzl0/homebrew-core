require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.41.tgz"
  sha256 "2c66a3f4a0c363f1c3e231b81d707c0c478b236519d34f22dfc7f5f6a0512e98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7afeca8138218754f3e75cd558c99f2d97621f140ed96d4c56c81626f94b1e42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7afeca8138218754f3e75cd558c99f2d97621f140ed96d4c56c81626f94b1e42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7afeca8138218754f3e75cd558c99f2d97621f140ed96d4c56c81626f94b1e42"
    sha256 cellar: :any_skip_relocation, sonoma:         "99e0099e3c0b53e8ca144df0c82c28a89a33f5c6600246ba7be2a6bea19e1658"
    sha256 cellar: :any_skip_relocation, ventura:        "99e0099e3c0b53e8ca144df0c82c28a89a33f5c6600246ba7be2a6bea19e1658"
    sha256 cellar: :any_skip_relocation, monterey:       "99e0099e3c0b53e8ca144df0c82c28a89a33f5c6600246ba7be2a6bea19e1658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7afeca8138218754f3e75cd558c99f2d97621f140ed96d4c56c81626f94b1e42"
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
