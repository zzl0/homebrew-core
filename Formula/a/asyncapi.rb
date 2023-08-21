require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.54.1.tgz"
  sha256 "fb7e09f35addc9551bb7b291eed5dd2e97567ddf82bca7fa043869b938cb0c2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b1049ad1a4818233b212968c634125517261424b2b2e18953b602594b3bdaf61"
    sha256 cellar: :any,                 arm64_monterey: "b1049ad1a4818233b212968c634125517261424b2b2e18953b602594b3bdaf61"
    sha256 cellar: :any,                 arm64_big_sur:  "b1049ad1a4818233b212968c634125517261424b2b2e18953b602594b3bdaf61"
    sha256 cellar: :any,                 ventura:        "9f56d410aae4fd5436251e1a21fd748cbdaee49603098ec74a15282cef944246"
    sha256 cellar: :any,                 monterey:       "9f56d410aae4fd5436251e1a21fd748cbdaee49603098ec74a15282cef944246"
    sha256 cellar: :any,                 big_sur:        "9f56d410aae4fd5436251e1a21fd748cbdaee49603098ec74a15282cef944246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b28a634a106bc51d122f25418fe078fcb9097ae51313ccc9a77223ac35a7eb"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
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
