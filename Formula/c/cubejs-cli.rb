require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.11.tgz"
  sha256 "aeb5db89538323beffed06073cfb9492126095819d530bfd572e3f2c84123edd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "942b40f18eed1c268580e7da45a4b2e954c20e06c9f446215f0af8975a86afce"
    sha256 cellar: :any, arm64_ventura:  "942b40f18eed1c268580e7da45a4b2e954c20e06c9f446215f0af8975a86afce"
    sha256 cellar: :any, arm64_monterey: "942b40f18eed1c268580e7da45a4b2e954c20e06c9f446215f0af8975a86afce"
    sha256 cellar: :any, sonoma:         "cfcf07085b2827dd4191efbdc11bace254dcb151f0d7d6717f820864cd20ed70"
    sha256 cellar: :any, ventura:        "cfcf07085b2827dd4191efbdc11bace254dcb151f0d7d6717f820864cd20ed70"
    sha256 cellar: :any, monterey:       "cfcf07085b2827dd4191efbdc11bace254dcb151f0d7d6717f820864cd20ed70"
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
