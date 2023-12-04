require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.30.tgz"
  sha256 "456f7110a9b115788109bcf00c031ad31e88e75fe3c1c1539f439f74845249b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "0bc819955ab9c1c4a9e47bb3c42901f86ee675ef2c7efb7de60b2b47827d1627"
    sha256 cellar: :any, arm64_ventura:  "0bc819955ab9c1c4a9e47bb3c42901f86ee675ef2c7efb7de60b2b47827d1627"
    sha256 cellar: :any, arm64_monterey: "0bc819955ab9c1c4a9e47bb3c42901f86ee675ef2c7efb7de60b2b47827d1627"
    sha256 cellar: :any, sonoma:         "433c9892f8dafc5c08098c12cd9414e57bb49745586a5f2a5de5d4f426cf9a3a"
    sha256 cellar: :any, ventura:        "433c9892f8dafc5c08098c12cd9414e57bb49745586a5f2a5de5d4f426cf9a3a"
    sha256 cellar: :any, monterey:       "433c9892f8dafc5c08098c12cd9414e57bb49745586a5f2a5de5d4f426cf9a3a"
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
