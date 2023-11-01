require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.6.tgz"
  sha256 "73ae30dfb311cab2262b5a75484ca8ea14c9052087a52a78dae6fae6f5abb775"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a113396ca7008d65b633cbce64b24fb69b9f82e99804f65eba68dc67dcba16b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a113396ca7008d65b633cbce64b24fb69b9f82e99804f65eba68dc67dcba16b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a113396ca7008d65b633cbce64b24fb69b9f82e99804f65eba68dc67dcba16b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a35941c43208956d9cf53bc825f0b4a32ec297e8a2c1d75072b276c980fec498"
    sha256 cellar: :any_skip_relocation, ventura:        "a35941c43208956d9cf53bc825f0b4a32ec297e8a2c1d75072b276c980fec498"
    sha256 cellar: :any_skip_relocation, monterey:       "a35941c43208956d9cf53bc825f0b4a32ec297e8a2c1d75072b276c980fec498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a113396ca7008d65b633cbce64b24fb69b9f82e99804f65eba68dc67dcba16b3"
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
