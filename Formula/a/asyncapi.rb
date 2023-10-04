require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.58.4.tgz"
  sha256 "a5a36cda92ee9bbdb0757f48d84c015cb7ef5614465a37129a18cce3f0cf5f95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94493090a810836c0378bf2d91b703c41b227db9447529ea5414f65ea66d8baf"
    sha256 cellar: :any,                 arm64_ventura:  "94493090a810836c0378bf2d91b703c41b227db9447529ea5414f65ea66d8baf"
    sha256 cellar: :any,                 arm64_monterey: "94493090a810836c0378bf2d91b703c41b227db9447529ea5414f65ea66d8baf"
    sha256 cellar: :any,                 sonoma:         "f18866e051bfcfe82a9d0941a34e915c66d8618174515f63fa2c68d8789063b9"
    sha256 cellar: :any,                 ventura:        "f18866e051bfcfe82a9d0941a34e915c66d8618174515f63fa2c68d8789063b9"
    sha256 cellar: :any,                 monterey:       "f18866e051bfcfe82a9d0941a34e915c66d8618174515f63fa2c68d8789063b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b299c3703cef640f8068fe6812f2d320064d10080fd09a5d610f4cedc55372"
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
