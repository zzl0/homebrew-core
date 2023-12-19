require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.30.tgz"
  sha256 "f7215dbac25c2cbceb0f7ca2e7ef088b7868e95bd371f13ecd9d735e4b3ce9f0"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87d6e274419851d8b2250f9a603ff0c50d6c52cd41862d11bb071f349241493c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87d6e274419851d8b2250f9a603ff0c50d6c52cd41862d11bb071f349241493c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87d6e274419851d8b2250f9a603ff0c50d6c52cd41862d11bb071f349241493c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c968df323fd49a9c46921ca8808eb83280bed63a1065b98dac3152f45f04ce97"
    sha256 cellar: :any_skip_relocation, ventura:        "c968df323fd49a9c46921ca8808eb83280bed63a1065b98dac3152f45f04ce97"
    sha256 cellar: :any_skip_relocation, monterey:       "c968df323fd49a9c46921ca8808eb83280bed63a1065b98dac3152f45f04ce97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d6e274419851d8b2250f9a603ff0c50d6c52cd41862d11bb071f349241493c"
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
