require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.9.tgz"
  sha256 "22e2e4211801b3221c6bc9ea6f27eff3d72792b21506b60634519f88a6011a70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7998e28369e75bda55edbf9e9f3a07764a1f0672ed0818d3e881d6110be697e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7998e28369e75bda55edbf9e9f3a07764a1f0672ed0818d3e881d6110be697e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7998e28369e75bda55edbf9e9f3a07764a1f0672ed0818d3e881d6110be697e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdb1be51738d949189193af50f83f940343dcb6825d7975c463c73cc2f7d0803"
    sha256 cellar: :any_skip_relocation, ventura:        "fdb1be51738d949189193af50f83f940343dcb6825d7975c463c73cc2f7d0803"
    sha256 cellar: :any_skip_relocation, monterey:       "fdb1be51738d949189193af50f83f940343dcb6825d7975c463c73cc2f7d0803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7998e28369e75bda55edbf9e9f3a07764a1f0672ed0818d3e881d6110be697e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
