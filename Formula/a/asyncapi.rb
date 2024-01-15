require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.3.0.tgz"
  sha256 "6a67859b78a3eab62d81e1de54c5989ba892404645432db7c909c4aab5ab8dad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f01e26bd435c5c14eb62580b31bf59076bf055f739e63517e41e89756ce0f9d"
    sha256 cellar: :any,                 arm64_ventura:  "4f01e26bd435c5c14eb62580b31bf59076bf055f739e63517e41e89756ce0f9d"
    sha256 cellar: :any,                 arm64_monterey: "4f01e26bd435c5c14eb62580b31bf59076bf055f739e63517e41e89756ce0f9d"
    sha256 cellar: :any,                 sonoma:         "7c8eefcec75b3d5b114046e55584bdd2d71ae81f98cc7052fb5c30e4fb868f9d"
    sha256 cellar: :any,                 ventura:        "7c8eefcec75b3d5b114046e55584bdd2d71ae81f98cc7052fb5c30e4fb868f9d"
    sha256 cellar: :any,                 monterey:       "7c8eefcec75b3d5b114046e55584bdd2d71ae81f98cc7052fb5c30e4fb868f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53deed17b6d1a80507fd7dd0f66ab2a4a0ee3620afa8ca72e8454d792326a675"
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
