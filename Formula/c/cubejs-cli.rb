require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.52.tgz"
  sha256 "d79e84706540d4958ed1705ae2711bd28d9b0ca28ac7f6bce1ecc2dd1cdc5244"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b22acd1463965c60f0ca749228efbe309f1433850df9de6713a4edead096e50e"
    sha256 cellar: :any, arm64_monterey: "b22acd1463965c60f0ca749228efbe309f1433850df9de6713a4edead096e50e"
    sha256 cellar: :any, arm64_big_sur:  "b22acd1463965c60f0ca749228efbe309f1433850df9de6713a4edead096e50e"
    sha256 cellar: :any, ventura:        "f1b0b9fc7fd9ac65903257c4e0e9df529a83d2d01e152ae83b833e952bf3d562"
    sha256 cellar: :any, monterey:       "f1b0b9fc7fd9ac65903257c4e0e9df529a83d2d01e152ae83b833e952bf3d562"
    sha256 cellar: :any, big_sur:        "f1b0b9fc7fd9ac65903257c4e0e9df529a83d2d01e152ae83b833e952bf3d562"
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
