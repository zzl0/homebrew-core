require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.39.0.tgz"
  sha256 "fa11a9de7c3a2e6d829724bacb8ded946efa46ebf6fc167c45cb18b148e4415e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da04bc0a68389ca9fc8b1384e34faa9c571fe10facad04174b9d9a7e4fe68b38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da04bc0a68389ca9fc8b1384e34faa9c571fe10facad04174b9d9a7e4fe68b38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da04bc0a68389ca9fc8b1384e34faa9c571fe10facad04174b9d9a7e4fe68b38"
    sha256 cellar: :any_skip_relocation, ventura:        "1fd9d3010f051d19badd9b2cdb0356d6f29993624c3fa7f2d9029e942d13f874"
    sha256 cellar: :any_skip_relocation, monterey:       "1fd9d3010f051d19badd9b2cdb0356d6f29993624c3fa7f2d9029e942d13f874"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fd9d3010f051d19badd9b2cdb0356d6f29993624c3fa7f2d9029e942d13f874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da04bc0a68389ca9fc8b1384e34faa9c571fe10facad04174b9d9a7e4fe68b38"
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
