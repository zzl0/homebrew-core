require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.18.tgz"
  sha256 "32687becabe6b25f4923be14726f0ae2133905a53408f478f55f53961d39a187"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8caf28b45009383fcabe4ec3a8127147dd3b5eca5037a63e58c6d7a1a4881ba6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8caf28b45009383fcabe4ec3a8127147dd3b5eca5037a63e58c6d7a1a4881ba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8caf28b45009383fcabe4ec3a8127147dd3b5eca5037a63e58c6d7a1a4881ba6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ad82cc6f4d80088ffee7c2f5a08da533bd1f09cec4c570a459cf0f8b0216061"
    sha256 cellar: :any_skip_relocation, ventura:        "9ad82cc6f4d80088ffee7c2f5a08da533bd1f09cec4c570a459cf0f8b0216061"
    sha256 cellar: :any_skip_relocation, monterey:       "9ad82cc6f4d80088ffee7c2f5a08da533bd1f09cec4c570a459cf0f8b0216061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8caf28b45009383fcabe4ec3a8127147dd3b5eca5037a63e58c6d7a1a4881ba6"
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
