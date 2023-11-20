require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.60.3.tgz"
  sha256 "cfc783ad2a2514f7ab0bf17fe47885aede0e6e8ffb78907d36bd435b6dda1b27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b20799d48e358330c443761a66da11c018eed336bedc06e747440f73b2ce2bbe"
    sha256 cellar: :any,                 arm64_ventura:  "b20799d48e358330c443761a66da11c018eed336bedc06e747440f73b2ce2bbe"
    sha256 cellar: :any,                 arm64_monterey: "b20799d48e358330c443761a66da11c018eed336bedc06e747440f73b2ce2bbe"
    sha256 cellar: :any,                 sonoma:         "1b1e341a53f4051bcc22b1a82f1287abafafdcd27e51530f4bc6e47192883a33"
    sha256 cellar: :any,                 ventura:        "1b1e341a53f4051bcc22b1a82f1287abafafdcd27e51530f4bc6e47192883a33"
    sha256 cellar: :any,                 monterey:       "1b1e341a53f4051bcc22b1a82f1287abafafdcd27e51530f4bc6e47192883a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad20cdb0453db6fda53fdf0ea0790a7314f96715e2dfdb55933a81d1a169b06"
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
