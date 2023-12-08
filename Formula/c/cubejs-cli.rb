require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.32.tgz"
  sha256 "aca2e98e5ccfea53fb2cbcea43744433f6f647aaa5e718095cd74bafb56617b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "99810a04b6938d434635ab492743e86f1b2db40137cfab927ff573b681763bbf"
    sha256 cellar: :any, arm64_ventura:  "99810a04b6938d434635ab492743e86f1b2db40137cfab927ff573b681763bbf"
    sha256 cellar: :any, arm64_monterey: "99810a04b6938d434635ab492743e86f1b2db40137cfab927ff573b681763bbf"
    sha256 cellar: :any, sonoma:         "d675e45d2be9f1a9a59d87a480fbf1621a3cf1830a32ed4c966189cc09a1502d"
    sha256 cellar: :any, ventura:        "d675e45d2be9f1a9a59d87a480fbf1621a3cf1830a32ed4c966189cc09a1502d"
    sha256 cellar: :any, monterey:       "d675e45d2be9f1a9a59d87a480fbf1621a3cf1830a32ed4c966189cc09a1502d"
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
