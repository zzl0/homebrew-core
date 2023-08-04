require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.43.tgz"
  sha256 "d011d6a4576a758ad42e321559ccca197dd2e996bd3c3d37975a650d4623d58e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "be230c75032c1cbfff6cbd84987a9c6c8cabf49d5d6dcb6943ef359210674516"
    sha256 cellar: :any, arm64_monterey: "be230c75032c1cbfff6cbd84987a9c6c8cabf49d5d6dcb6943ef359210674516"
    sha256 cellar: :any, arm64_big_sur:  "be230c75032c1cbfff6cbd84987a9c6c8cabf49d5d6dcb6943ef359210674516"
    sha256 cellar: :any, ventura:        "1b7fd9b986b9af496133d15eb1e92e61269f19a2baa86337ea1ffb7e564de855"
    sha256 cellar: :any, monterey:       "1b7fd9b986b9af496133d15eb1e92e61269f19a2baa86337ea1ffb7e564de855"
    sha256 cellar: :any, big_sur:        "1b7fd9b986b9af496133d15eb1e92e61269f19a2baa86337ea1ffb7e564de855"
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
