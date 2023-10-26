require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.3.tgz"
  sha256 "8996f40496bff33d2ec7f07fd772ca01b52800b908fecc31e8f94540d25d58ba"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7fc40e3bffabbb91a4fa9b0bb2f58d013d964482fd48973ff92baaad1e99a7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7fc40e3bffabbb91a4fa9b0bb2f58d013d964482fd48973ff92baaad1e99a7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7fc40e3bffabbb91a4fa9b0bb2f58d013d964482fd48973ff92baaad1e99a7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bfc8d74dea0bd10a15b71fb0ec04af14767546f0ec47e59ebdfb2b51ce9b49d"
    sha256 cellar: :any_skip_relocation, ventura:        "0bfc8d74dea0bd10a15b71fb0ec04af14767546f0ec47e59ebdfb2b51ce9b49d"
    sha256 cellar: :any_skip_relocation, monterey:       "0bfc8d74dea0bd10a15b71fb0ec04af14767546f0ec47e59ebdfb2b51ce9b49d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7fc40e3bffabbb91a4fa9b0bb2f58d013d964482fd48973ff92baaad1e99a7c"
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
