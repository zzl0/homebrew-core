require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.46.tgz"
  sha256 "cc8713ccd1c6b99ea1a429d2c392e1979f4b40b2d2fccffd0736bcc381e98ff9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3584e026d1fa0e90b2ceb03a1589d0c40eef1bcd12aa90c82ec2c11ef5c57391"
    sha256 cellar: :any, arm64_monterey: "3584e026d1fa0e90b2ceb03a1589d0c40eef1bcd12aa90c82ec2c11ef5c57391"
    sha256 cellar: :any, arm64_big_sur:  "3584e026d1fa0e90b2ceb03a1589d0c40eef1bcd12aa90c82ec2c11ef5c57391"
    sha256 cellar: :any, ventura:        "6bf065b9febdff2d6a00d05f2f7a194c121e4b3280b0e80877ef0a81aa5a01d8"
    sha256 cellar: :any, monterey:       "6bf065b9febdff2d6a00d05f2f7a194c121e4b3280b0e80877ef0a81aa5a01d8"
    sha256 cellar: :any, big_sur:        "6bf065b9febdff2d6a00d05f2f7a194c121e4b3280b0e80877ef0a81aa5a01d8"
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
