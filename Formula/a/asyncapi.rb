require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.16.tgz"
  sha256 "297cbcb6f0722b55eaaaf8c32e222ba235a7a3b27b2386f3098284cbdb83c703"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "015428619673eec0d07d80b5e15e1196c27c74e9d5285c6d11e32e183f45bf2d"
    sha256 cellar: :any,                 arm64_ventura:  "015428619673eec0d07d80b5e15e1196c27c74e9d5285c6d11e32e183f45bf2d"
    sha256 cellar: :any,                 arm64_monterey: "015428619673eec0d07d80b5e15e1196c27c74e9d5285c6d11e32e183f45bf2d"
    sha256 cellar: :any,                 sonoma:         "90d7b962c2efe66f5b613bfa460b3f95e47e3b6107ece41989e0ed2ffd1e3206"
    sha256 cellar: :any,                 ventura:        "90d7b962c2efe66f5b613bfa460b3f95e47e3b6107ece41989e0ed2ffd1e3206"
    sha256 cellar: :any,                 monterey:       "90d7b962c2efe66f5b613bfa460b3f95e47e3b6107ece41989e0ed2ffd1e3206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db3248771a93dfa5d3fc0ff8c24c9e831f9ee7d89f03c4e467cae62cce78933b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
