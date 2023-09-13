require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.56.tgz"
  sha256 "91c5cf28ec536e5553b7fa125bfd17744de116213257d9f1af512716578634ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "37389d9a8210f2e5e279822ac253adb65f2848c38d6e648f71f775d2efe93b49"
    sha256 cellar: :any, arm64_monterey: "37389d9a8210f2e5e279822ac253adb65f2848c38d6e648f71f775d2efe93b49"
    sha256 cellar: :any, arm64_big_sur:  "37389d9a8210f2e5e279822ac253adb65f2848c38d6e648f71f775d2efe93b49"
    sha256 cellar: :any, ventura:        "c6486e50a1273ef964f4b2a4df0ba0cf348795841d667683822252582d5a9f0d"
    sha256 cellar: :any, monterey:       "c6486e50a1273ef964f4b2a4df0ba0cf348795841d667683822252582d5a9f0d"
    sha256 cellar: :any, big_sur:        "c6486e50a1273ef964f4b2a4df0ba0cf348795841d667683822252582d5a9f0d"
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
