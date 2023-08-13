require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.45.tgz"
  sha256 "bc384a452d145c76e8ea642e7573ce362c9931d2ff726bc5bf82b5514cf0ccd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b6157a82d621f1817b35c8bd5f30d72510dd59e512018709fd1cd9deff1a211b"
    sha256 cellar: :any, arm64_monterey: "b6157a82d621f1817b35c8bd5f30d72510dd59e512018709fd1cd9deff1a211b"
    sha256 cellar: :any, arm64_big_sur:  "b6157a82d621f1817b35c8bd5f30d72510dd59e512018709fd1cd9deff1a211b"
    sha256 cellar: :any, ventura:        "aed157701a6475baa8253a9d5f0c45b79dbdcab871a9c6ccb49b8dfc8a5cd69c"
    sha256 cellar: :any, monterey:       "aed157701a6475baa8253a9d5f0c45b79dbdcab871a9c6ccb49b8dfc8a5cd69c"
    sha256 cellar: :any, big_sur:        "aed157701a6475baa8253a9d5f0c45b79dbdcab871a9c6ccb49b8dfc8a5cd69c"
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
