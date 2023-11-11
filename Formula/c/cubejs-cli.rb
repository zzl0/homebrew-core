require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.18.tgz"
  sha256 "ad7da6529cecbd494dfca0eea65e3a1e420ffa6a39d8502d60caee606efdb6e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "3d165c115cc32891ca0549cf0709e1cda8638d719d95222e2c48c644d6952ca1"
    sha256 cellar: :any, arm64_ventura:  "3d165c115cc32891ca0549cf0709e1cda8638d719d95222e2c48c644d6952ca1"
    sha256 cellar: :any, arm64_monterey: "3d165c115cc32891ca0549cf0709e1cda8638d719d95222e2c48c644d6952ca1"
    sha256 cellar: :any, sonoma:         "efaf4067d0e00aaec8a32f3b580d3a58aad22897842d828245e159232869c2a9"
    sha256 cellar: :any, ventura:        "efaf4067d0e00aaec8a32f3b580d3a58aad22897842d828245e159232869c2a9"
    sha256 cellar: :any, monterey:       "efaf4067d0e00aaec8a32f3b580d3a58aad22897842d828245e159232869c2a9"
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
