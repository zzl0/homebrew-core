require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.3.tgz"
  sha256 "3d01c7aec975d231af5a7e5699ce6011aaab3d9255e6b0d60fee192001f397fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "599f15f1d3c8dc1ae6980eb87ed5da8db191734eab22aa8456002ded7daea64b"
    sha256 cellar: :any, arm64_ventura:  "599f15f1d3c8dc1ae6980eb87ed5da8db191734eab22aa8456002ded7daea64b"
    sha256 cellar: :any, arm64_monterey: "599f15f1d3c8dc1ae6980eb87ed5da8db191734eab22aa8456002ded7daea64b"
    sha256 cellar: :any, sonoma:         "15849c69651eca7ea926bfe89b6a2c483ceef258606a80e892a4c967dc236a8f"
    sha256 cellar: :any, ventura:        "15849c69651eca7ea926bfe89b6a2c483ceef258606a80e892a4c967dc236a8f"
    sha256 cellar: :any, monterey:       "15849c69651eca7ea926bfe89b6a2c483ceef258606a80e892a4c967dc236a8f"
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
