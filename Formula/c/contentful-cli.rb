require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.0.13.tgz"
  sha256 "89f58f1621ea8b7964534b311fc3572109628dbda4bbea740b87e4fb397948cc"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e708b44ec294f1a46685e65d199930f907a04bf0bcfc491516dd0d1a508a71f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e708b44ec294f1a46685e65d199930f907a04bf0bcfc491516dd0d1a508a71f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e708b44ec294f1a46685e65d199930f907a04bf0bcfc491516dd0d1a508a71f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4682ac5939f0419e985c861a4be8df1013d880e14afe00e1b515ee2b842bdc9e"
    sha256 cellar: :any_skip_relocation, ventura:        "4682ac5939f0419e985c861a4be8df1013d880e14afe00e1b515ee2b842bdc9e"
    sha256 cellar: :any_skip_relocation, monterey:       "4682ac5939f0419e985c861a4be8df1013d880e14afe00e1b515ee2b842bdc9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e708b44ec294f1a46685e65d199930f907a04bf0bcfc491516dd0d1a508a71f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
