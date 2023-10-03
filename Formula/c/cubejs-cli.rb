require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.0.tgz"
  sha256 "d6207c3dfd13eeaaab49065e0d47f02930b33845298a5f9aeef5b69b0ab55ca1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5c547668f1a9fb376781f0ed7280d0f6cc63024fc8d9a02299013dc480765dc2"
    sha256 cellar: :any, arm64_ventura:  "5c547668f1a9fb376781f0ed7280d0f6cc63024fc8d9a02299013dc480765dc2"
    sha256 cellar: :any, arm64_monterey: "5c547668f1a9fb376781f0ed7280d0f6cc63024fc8d9a02299013dc480765dc2"
    sha256 cellar: :any, sonoma:         "54fe625325adbd7c97530bcdf379e998e39eed9d727260350103217d9128719f"
    sha256 cellar: :any, ventura:        "54fe625325adbd7c97530bcdf379e998e39eed9d727260350103217d9128719f"
    sha256 cellar: :any, monterey:       "54fe625325adbd7c97530bcdf379e998e39eed9d727260350103217d9128719f"
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
