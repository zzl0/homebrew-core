require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.57.tgz"
  sha256 "d7a7fd65af37414cffd25cea11770205a5ce2eb44fb9d77548d135ebc9e90ce8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "8af0b606b94bdaf29238b97b84ba04e7391b357323be2e53dc5e3748296f9d1a"
    sha256 cellar: :any, arm64_monterey: "8af0b606b94bdaf29238b97b84ba04e7391b357323be2e53dc5e3748296f9d1a"
    sha256 cellar: :any, arm64_big_sur:  "8af0b606b94bdaf29238b97b84ba04e7391b357323be2e53dc5e3748296f9d1a"
    sha256 cellar: :any, ventura:        "446aa645b6dd42439ac47a746c455c483308e13750c83b9e42d7d4c8dd5849ec"
    sha256 cellar: :any, monterey:       "446aa645b6dd42439ac47a746c455c483308e13750c83b9e42d7d4c8dd5849ec"
    sha256 cellar: :any, big_sur:        "446aa645b6dd42439ac47a746c455c483308e13750c83b9e42d7d4c8dd5849ec"
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
