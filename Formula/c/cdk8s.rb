require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.36.tgz"
  sha256 "ee4d43a68b82e109551550a888af1cac8a677bb5fc1448c8e2848d58b2fed082"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "822315c341cac0169fb4ab812ba64bb7e5a25d370b1b3c10d3fda332a53ac76c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "822315c341cac0169fb4ab812ba64bb7e5a25d370b1b3c10d3fda332a53ac76c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "822315c341cac0169fb4ab812ba64bb7e5a25d370b1b3c10d3fda332a53ac76c"
    sha256 cellar: :any_skip_relocation, sonoma:         "694ef7b74470fc5a066fdb3cb64810af51485cca6215fbbf8ab0429b2508cd03"
    sha256 cellar: :any_skip_relocation, ventura:        "694ef7b74470fc5a066fdb3cb64810af51485cca6215fbbf8ab0429b2508cd03"
    sha256 cellar: :any_skip_relocation, monterey:       "694ef7b74470fc5a066fdb3cb64810af51485cca6215fbbf8ab0429b2508cd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "822315c341cac0169fb4ab812ba64bb7e5a25d370b1b3c10d3fda332a53ac76c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
