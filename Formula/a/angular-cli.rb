require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.10.tgz"
  sha256 "60f5b37de01c3aa2bbb512be168fe6f7bb7df25d110288eb7ca32b98659cf7f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e76eec5b224d4ddac2bb9660d8cf9ea86c7755486ea1665188a258bd924e4a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e76eec5b224d4ddac2bb9660d8cf9ea86c7755486ea1665188a258bd924e4a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e76eec5b224d4ddac2bb9660d8cf9ea86c7755486ea1665188a258bd924e4a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b0c21a6a99480a9fd889ae00fe8784003647f98fbafdcda62dd346b505fcdc0"
    sha256 cellar: :any_skip_relocation, ventura:        "4b0c21a6a99480a9fd889ae00fe8784003647f98fbafdcda62dd346b505fcdc0"
    sha256 cellar: :any_skip_relocation, monterey:       "4b0c21a6a99480a9fd889ae00fe8784003647f98fbafdcda62dd346b505fcdc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e76eec5b224d4ddac2bb9660d8cf9ea86c7755486ea1665188a258bd924e4a3"
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
