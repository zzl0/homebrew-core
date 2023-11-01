require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.13.tgz"
  sha256 "cec613d59d38d49efa8d2699d5d1742d6e1b4e8168c252679dac2243c661dfdf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "52c7809a1e71208a256dffbbfc1b0a17ff7c42e8bbd40f9fb2113bf2f7135884"
    sha256 cellar: :any, arm64_ventura:  "52c7809a1e71208a256dffbbfc1b0a17ff7c42e8bbd40f9fb2113bf2f7135884"
    sha256 cellar: :any, arm64_monterey: "52c7809a1e71208a256dffbbfc1b0a17ff7c42e8bbd40f9fb2113bf2f7135884"
    sha256 cellar: :any, sonoma:         "190a111760704c2029b677e799f48e8f9d6837e8de1a8185c1edc960ed3c433c"
    sha256 cellar: :any, ventura:        "190a111760704c2029b677e799f48e8f9d6837e8de1a8185c1edc960ed3c433c"
    sha256 cellar: :any, monterey:       "190a111760704c2029b677e799f48e8f9d6837e8de1a8185c1edc960ed3c433c"
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
