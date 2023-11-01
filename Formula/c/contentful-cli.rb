require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.7.tgz"
  sha256 "e953ea9167bec98bdae8f9651ad2e6f3e4685d3e376b6bd4746c8fa2e3641fb2"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69f49dfa715f77384fe329438b31d39351fc8608e399852553e09363989602d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69f49dfa715f77384fe329438b31d39351fc8608e399852553e09363989602d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69f49dfa715f77384fe329438b31d39351fc8608e399852553e09363989602d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "29ce3bde51b76a5386d72ab3ca026937d6c738802f97b8836d5cf0a6f72271a3"
    sha256 cellar: :any_skip_relocation, ventura:        "29ce3bde51b76a5386d72ab3ca026937d6c738802f97b8836d5cf0a6f72271a3"
    sha256 cellar: :any_skip_relocation, monterey:       "29ce3bde51b76a5386d72ab3ca026937d6c738802f97b8836d5cf0a6f72271a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f49dfa715f77384fe329438b31d39351fc8608e399852553e09363989602d0"
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
