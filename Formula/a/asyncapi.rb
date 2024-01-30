require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.4.6.tgz"
  sha256 "f2f61b3520b86d630a9b744917012da2dc8ac44595beb1c1107b42e3a15e4c94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3eac508e49b3ced7ca118e9c6058a903e0b53abc6577d4da805cb075e3b7ece5"
    sha256 cellar: :any,                 arm64_ventura:  "3eac508e49b3ced7ca118e9c6058a903e0b53abc6577d4da805cb075e3b7ece5"
    sha256 cellar: :any,                 arm64_monterey: "3eac508e49b3ced7ca118e9c6058a903e0b53abc6577d4da805cb075e3b7ece5"
    sha256 cellar: :any,                 sonoma:         "eecc85e9a313a3afb7b9758e8115ff2d6a26d65db71e11a408b1abb55b721aec"
    sha256 cellar: :any,                 ventura:        "eecc85e9a313a3afb7b9758e8115ff2d6a26d65db71e11a408b1abb55b721aec"
    sha256 cellar: :any,                 monterey:       "eecc85e9a313a3afb7b9758e8115ff2d6a26d65db71e11a408b1abb55b721aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4be55a005ed404c54ecd5a9ec18da7d61266d90c6e5978cfba87bf57663c6827"
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
