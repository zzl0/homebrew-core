require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.3.2.tgz"
  sha256 "1a5598d5a3ec98937621f460b969a16df0351f9faba1049ed5bb70e19ce6bc37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d88c64844b95e6487f56162f02cf83f4f1b954ff5fa47bc1e83c8e28f6072871"
    sha256 cellar: :any,                 arm64_ventura:  "d88c64844b95e6487f56162f02cf83f4f1b954ff5fa47bc1e83c8e28f6072871"
    sha256 cellar: :any,                 arm64_monterey: "d88c64844b95e6487f56162f02cf83f4f1b954ff5fa47bc1e83c8e28f6072871"
    sha256 cellar: :any,                 sonoma:         "1a3ea789c69eb6a3a62a1c5b4829ea53d51ed170ff6dd4bfbf845dd6bcd222ef"
    sha256 cellar: :any,                 ventura:        "1a3ea789c69eb6a3a62a1c5b4829ea53d51ed170ff6dd4bfbf845dd6bcd222ef"
    sha256 cellar: :any,                 monterey:       "1a3ea789c69eb6a3a62a1c5b4829ea53d51ed170ff6dd4bfbf845dd6bcd222ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38a241a077d3dbd776c6689d15a7c29fbcd13879f8a0677d09cb4a4e23116ffe"
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
