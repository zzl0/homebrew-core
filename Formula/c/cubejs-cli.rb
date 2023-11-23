require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.24.tgz"
  sha256 "a0d66ee6e2231e265382d3f9d495952c61283bdd2a6d01061863a6a0e6ef39a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "aab985ebd2fdf1f531c5f15dfb2ebbc662fa990bbd3feb08b50da292d2ea1b73"
    sha256 cellar: :any, arm64_ventura:  "aab985ebd2fdf1f531c5f15dfb2ebbc662fa990bbd3feb08b50da292d2ea1b73"
    sha256 cellar: :any, arm64_monterey: "aab985ebd2fdf1f531c5f15dfb2ebbc662fa990bbd3feb08b50da292d2ea1b73"
    sha256 cellar: :any, sonoma:         "c88a80d79d05b55a3877c095524a6bfe0c2734323cd70c77186de8aef247ea96"
    sha256 cellar: :any, ventura:        "c88a80d79d05b55a3877c095524a6bfe0c2734323cd70c77186de8aef247ea96"
    sha256 cellar: :any, monterey:       "c88a80d79d05b55a3877c095524a6bfe0c2734323cd70c77186de8aef247ea96"
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
