require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.5.2.tgz"
  sha256 "5d30c53d72f545fc97df95df9b26bb220f3f1b403f8090b8ae47a19c580f8afe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d52f3cd332656b4e2b1737dbeafd13b692f629b946b391202612f625d92cbca"
    sha256 cellar: :any,                 arm64_ventura:  "7d52f3cd332656b4e2b1737dbeafd13b692f629b946b391202612f625d92cbca"
    sha256 cellar: :any,                 arm64_monterey: "7d52f3cd332656b4e2b1737dbeafd13b692f629b946b391202612f625d92cbca"
    sha256 cellar: :any,                 sonoma:         "22fd519498e5f83ca195a8ee502fe0fbc4232e96ce603642f06cbe59db6a5028"
    sha256 cellar: :any,                 ventura:        "22fd519498e5f83ca195a8ee502fe0fbc4232e96ce603642f06cbe59db6a5028"
    sha256 cellar: :any,                 monterey:       "22fd519498e5f83ca195a8ee502fe0fbc4232e96ce603642f06cbe59db6a5028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ac5fa583880a37a3529d6ec2bb18ce20753b110213cb57b730ca30e8ff4d590"
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
