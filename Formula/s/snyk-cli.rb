require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1242.0.tgz"
  sha256 "5d220676acf3a90c7eab836ae0ee0908f0b0872bcae6e07874c28a91280a2e09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab9ba4717eb93b1560996966645bfa45207748e525c05cf3bca5839653cdec44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4280f825aaab43dd180bafe9a140c16893f3817ae7cffec1c4d6e5a14995ce8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2575b3ce60c1c4e2e36cb25cf8e58fa71bd478a55fe53cea8ca1e0f74c44f34"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3a304593b944f157881a3f7874592dc12b777a26e0c68a0e7524eddd0980d15"
    sha256 cellar: :any_skip_relocation, ventura:        "a1cdb7ee1d950790f6c0dc5c4ef5af79a1791cf9f34089e8a1ee51b6beb1e543"
    sha256 cellar: :any_skip_relocation, monterey:       "9cf1e5548899a62b240ca2e8bdb60abb66d6ffa238f85705f448cbb93b0d4dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0af659363dcd58bfef9c0554496b0b15badc2689f7ea6ad1fed792c69e7afb1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
