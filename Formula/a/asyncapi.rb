require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.22.tgz"
  sha256 "af51e2734f8604f0e6c06084573f527e2e94cc03cf116a5df014ad892471073c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c1394d76fc796bf7930b84345cf0b793e8ecd4d637e870c0f3a6734f0e38fdfa"
    sha256 cellar: :any,                 arm64_ventura:  "c1394d76fc796bf7930b84345cf0b793e8ecd4d637e870c0f3a6734f0e38fdfa"
    sha256 cellar: :any,                 arm64_monterey: "c1394d76fc796bf7930b84345cf0b793e8ecd4d637e870c0f3a6734f0e38fdfa"
    sha256 cellar: :any,                 sonoma:         "39d9ae0342259a83d7c957cd0f6aa5d62acbd21b2f1b87b7196b026464d3619a"
    sha256 cellar: :any,                 ventura:        "39d9ae0342259a83d7c957cd0f6aa5d62acbd21b2f1b87b7196b026464d3619a"
    sha256 cellar: :any,                 monterey:       "39d9ae0342259a83d7c957cd0f6aa5d62acbd21b2f1b87b7196b026464d3619a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1582b45c836c94f5847ad38a4f534080dfc6ebc7a480d598bf76fc3fddd3221a"
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
