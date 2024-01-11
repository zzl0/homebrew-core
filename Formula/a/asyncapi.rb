require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.35.tgz"
  sha256 "bf3b4196ead1823f8982b9f6f0a3d9505f2e26580094f7aa35c2f229d7d8d433"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b372a5da68d55701ab1e5a892bc13a723bb5cb16da2fe9ad81c301c71efde17a"
    sha256 cellar: :any,                 arm64_ventura:  "b372a5da68d55701ab1e5a892bc13a723bb5cb16da2fe9ad81c301c71efde17a"
    sha256 cellar: :any,                 arm64_monterey: "b372a5da68d55701ab1e5a892bc13a723bb5cb16da2fe9ad81c301c71efde17a"
    sha256 cellar: :any,                 sonoma:         "ae51744d449c62968ec3661b705bb19d6056285cfdca541b68dbcd8de9ff69e4"
    sha256 cellar: :any,                 ventura:        "ae51744d449c62968ec3661b705bb19d6056285cfdca541b68dbcd8de9ff69e4"
    sha256 cellar: :any,                 monterey:       "ae51744d449c62968ec3661b705bb19d6056285cfdca541b68dbcd8de9ff69e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db0c49290ce067bcec2d8e7bc27e7869b0b3fac3eb581bf6a923e7eff9ecd583"
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
