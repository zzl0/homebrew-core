require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.3.1.tgz"
  sha256 "f1bd0f636f5cf383d4d726c08f8207b46c2e0d85518dd0fded5e66263dfd3778"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a867935d3d320a264c234a210351c3dfe5f6155de5d2b4ad961b91d9ccbabe9"
    sha256 cellar: :any,                 arm64_ventura:  "4a867935d3d320a264c234a210351c3dfe5f6155de5d2b4ad961b91d9ccbabe9"
    sha256 cellar: :any,                 arm64_monterey: "4a867935d3d320a264c234a210351c3dfe5f6155de5d2b4ad961b91d9ccbabe9"
    sha256 cellar: :any,                 sonoma:         "2c1e59117253f6cb3bae883e1f90b41c14667b7b0f005b4a6306a8b5ee56dc7b"
    sha256 cellar: :any,                 ventura:        "2c1e59117253f6cb3bae883e1f90b41c14667b7b0f005b4a6306a8b5ee56dc7b"
    sha256 cellar: :any,                 monterey:       "2c1e59117253f6cb3bae883e1f90b41c14667b7b0f005b4a6306a8b5ee56dc7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c9c29db7c092be7535ed6ba9425d2095fa686d6a083da6a0150c95d04e94b8c"
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
