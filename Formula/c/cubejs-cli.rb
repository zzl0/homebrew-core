require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.6.tgz"
  sha256 "b19be412fd02ca37df35117a8eb3c08bcfd02a37c02b1d3f03e1cc044ded9c33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a5b1e7bb3b60c998d620f50c93f0cf07fc88ca0737d6993508596b7af2d29ecb"
    sha256 cellar: :any, arm64_ventura:  "a5b1e7bb3b60c998d620f50c93f0cf07fc88ca0737d6993508596b7af2d29ecb"
    sha256 cellar: :any, arm64_monterey: "a5b1e7bb3b60c998d620f50c93f0cf07fc88ca0737d6993508596b7af2d29ecb"
    sha256 cellar: :any, sonoma:         "810818514ca2e2acf8de031d1c6103da1961d1700478580109293bb553490a58"
    sha256 cellar: :any, ventura:        "810818514ca2e2acf8de031d1c6103da1961d1700478580109293bb553490a58"
    sha256 cellar: :any, monterey:       "810818514ca2e2acf8de031d1c6103da1961d1700478580109293bb553490a58"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
