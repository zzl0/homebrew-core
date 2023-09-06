require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.51.tgz"
  sha256 "2d62240a58f0d3231b6fbdfbd667a87b673d33c252f7582129c1869f1c49ea6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "bf92830ccc0161198840d46ad6d9db422545a6198ce7afe6aa8a1f586de6fc35"
    sha256 cellar: :any, arm64_monterey: "bf92830ccc0161198840d46ad6d9db422545a6198ce7afe6aa8a1f586de6fc35"
    sha256 cellar: :any, arm64_big_sur:  "bf92830ccc0161198840d46ad6d9db422545a6198ce7afe6aa8a1f586de6fc35"
    sha256 cellar: :any, ventura:        "141ae0da88398727b8c86f0c6a36b0b626ab4a170eb3e1fc6dff5c5e4fa3f7f7"
    sha256 cellar: :any, monterey:       "141ae0da88398727b8c86f0c6a36b0b626ab4a170eb3e1fc6dff5c5e4fa3f7f7"
    sha256 cellar: :any, big_sur:        "141ae0da88398727b8c86f0c6a36b0b626ab4a170eb3e1fc6dff5c5e4fa3f7f7"
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
