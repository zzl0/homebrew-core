require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.37.tgz"
  sha256 "5c4980a3eace06f2a2bfebf15758e831ea5097011ccddccca842c3d3c0e759a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6dcb35c32c95b3457c613fe41d6238b3eecb11a75a7498e4d7bb4e27f9ce9209"
    sha256 cellar: :any, arm64_ventura:  "6dcb35c32c95b3457c613fe41d6238b3eecb11a75a7498e4d7bb4e27f9ce9209"
    sha256 cellar: :any, arm64_monterey: "6dcb35c32c95b3457c613fe41d6238b3eecb11a75a7498e4d7bb4e27f9ce9209"
    sha256 cellar: :any, sonoma:         "872719bea540b8f3d4ab8e7f68f3e9550ea4b3ca992050659e47cb61b0705687"
    sha256 cellar: :any, ventura:        "872719bea540b8f3d4ab8e7f68f3e9550ea4b3ca992050659e47cb61b0705687"
    sha256 cellar: :any, monterey:       "872719bea540b8f3d4ab8e7f68f3e9550ea4b3ca992050659e47cb61b0705687"
  end

  depends_on "node"
  uses_from_macos "zlib"

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
