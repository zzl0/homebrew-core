require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.31.tgz"
  sha256 "dca2cdb221687cec11d32744ea79c3de6962a6d71cda2fad897aa8f8b2b14e11"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1501678b36f9ab444177f4f8e622f7321929246899ddb387fc47786af0278426"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1501678b36f9ab444177f4f8e622f7321929246899ddb387fc47786af0278426"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1501678b36f9ab444177f4f8e622f7321929246899ddb387fc47786af0278426"
    sha256 cellar: :any_skip_relocation, ventura:        "f918a27dc6e2d1363f08a8211cf0c4456a2b5988c594bcc7260c596ba6f393dc"
    sha256 cellar: :any_skip_relocation, monterey:       "f918a27dc6e2d1363f08a8211cf0c4456a2b5988c594bcc7260c596ba6f393dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f918a27dc6e2d1363f08a8211cf0c4456a2b5988c594bcc7260c596ba6f393dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5808adce9c11c60eb0cdf783e0037cbb52d98fdf4a339dd98a7608dc3824cef1"
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
