require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.4.2.tgz"
  sha256 "1803c2f09c88a2621c0ccb261327de30d308e5c55bbafee4b1f6d83d56ef503f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e8a09b4e969f79431a2d0c35926ab4f0e537b8d3e7ee6e6f79bea9117edcfe10"
    sha256 cellar: :any,                 arm64_ventura:  "e8a09b4e969f79431a2d0c35926ab4f0e537b8d3e7ee6e6f79bea9117edcfe10"
    sha256 cellar: :any,                 arm64_monterey: "e8a09b4e969f79431a2d0c35926ab4f0e537b8d3e7ee6e6f79bea9117edcfe10"
    sha256 cellar: :any,                 sonoma:         "e1bf14aac58af7048092366cabd86d05fe87b14b33e68e8e73c270dbbd0dd742"
    sha256 cellar: :any,                 ventura:        "e1bf14aac58af7048092366cabd86d05fe87b14b33e68e8e73c270dbbd0dd742"
    sha256 cellar: :any,                 monterey:       "e1bf14aac58af7048092366cabd86d05fe87b14b33e68e8e73c270dbbd0dd742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eaf1831402fe462b2e9a456c7e7706efb88b930b18e55c6626205b306e63b95"
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
