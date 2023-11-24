require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.25.tgz"
  sha256 "01fb2c7ac5f5c3b18e369f29859c5cbb42e0663641943ac0f171689b49ae079a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5dda5dd5eea5057a392fe249e57375ed96659a36bf33dbff5d0bed088a1a9d64"
    sha256 cellar: :any, arm64_ventura:  "5dda5dd5eea5057a392fe249e57375ed96659a36bf33dbff5d0bed088a1a9d64"
    sha256 cellar: :any, arm64_monterey: "5dda5dd5eea5057a392fe249e57375ed96659a36bf33dbff5d0bed088a1a9d64"
    sha256 cellar: :any, sonoma:         "3dbe98f5e983054f848cd7ba7d124683440ea09f6ef2fb02b2244fb247766c12"
    sha256 cellar: :any, ventura:        "3dbe98f5e983054f848cd7ba7d124683440ea09f6ef2fb02b2244fb247766c12"
    sha256 cellar: :any, monterey:       "3dbe98f5e983054f848cd7ba7d124683440ea09f6ef2fb02b2244fb247766c12"
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
