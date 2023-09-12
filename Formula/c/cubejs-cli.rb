require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.55.tgz"
  sha256 "3e004a42abf86969f76191877a86952cea5494df6f74c00012b96e0770d09fd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "670c0664a81fd08b552811cdd8eaaf4a7de9b739ef84be6f106ee56fbad3d9b9"
    sha256 cellar: :any, arm64_monterey: "670c0664a81fd08b552811cdd8eaaf4a7de9b739ef84be6f106ee56fbad3d9b9"
    sha256 cellar: :any, arm64_big_sur:  "670c0664a81fd08b552811cdd8eaaf4a7de9b739ef84be6f106ee56fbad3d9b9"
    sha256 cellar: :any, ventura:        "6fcac0346ec720821a9a11910c6524e61123544e1ffb46b7cef76afecd9839c7"
    sha256 cellar: :any, monterey:       "6fcac0346ec720821a9a11910c6524e61123544e1ffb46b7cef76afecd9839c7"
    sha256 cellar: :any, big_sur:        "6fcac0346ec720821a9a11910c6524e61123544e1ffb46b7cef76afecd9839c7"
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
