require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.35.tgz"
  sha256 "67188549e20051a95a3e5376a79b1ac00b0b915981fb91aeca832140c564e824"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e5b93760dc4f281eee38eb0822afe620f9038e28266e0d584ab9fb4704b8b22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e5b93760dc4f281eee38eb0822afe620f9038e28266e0d584ab9fb4704b8b22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e5b93760dc4f281eee38eb0822afe620f9038e28266e0d584ab9fb4704b8b22"
    sha256 cellar: :any_skip_relocation, ventura:        "246066da1ad3e130424eaad9cfd2ec1fd34ba9fac4611b98afc5de8e33b94ea1"
    sha256 cellar: :any_skip_relocation, monterey:       "246066da1ad3e130424eaad9cfd2ec1fd34ba9fac4611b98afc5de8e33b94ea1"
    sha256 cellar: :any_skip_relocation, big_sur:        "246066da1ad3e130424eaad9cfd2ec1fd34ba9fac4611b98afc5de8e33b94ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39b0b2ebb307e665e41bf3d8f18d3c5c11c4d380703be4b971d6df83e3b5cc56"
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
