require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.0.5.tgz"
  sha256 "ed7f100c7f6ffaa78ab80d53fe0e9c3fab3a8929aac8a223dc4363322a7292c7"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0789494df05e34147160b36b720e0ecd3b4ea5dc10bd382428464c4dd1694a0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0789494df05e34147160b36b720e0ecd3b4ea5dc10bd382428464c4dd1694a0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0789494df05e34147160b36b720e0ecd3b4ea5dc10bd382428464c4dd1694a0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d41251911929c54ed11ccae6c1c893bbde05271107505fa53e92788a999ead11"
    sha256 cellar: :any_skip_relocation, ventura:        "d41251911929c54ed11ccae6c1c893bbde05271107505fa53e92788a999ead11"
    sha256 cellar: :any_skip_relocation, monterey:       "d41251911929c54ed11ccae6c1c893bbde05271107505fa53e92788a999ead11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0789494df05e34147160b36b720e0ecd3b4ea5dc10bd382428464c4dd1694a0d"
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
