require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.25.tgz"
  sha256 "b7d1c88cd763271fb2d232f2556b7e3b16536ff32305e385a3bc4368b0f6922c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b0d3f1df913bb184acdd7fe9529b8abf4deeb10797949329285f2d46f854f632"
    sha256 cellar: :any,                 arm64_ventura:  "b0d3f1df913bb184acdd7fe9529b8abf4deeb10797949329285f2d46f854f632"
    sha256 cellar: :any,                 arm64_monterey: "b0d3f1df913bb184acdd7fe9529b8abf4deeb10797949329285f2d46f854f632"
    sha256 cellar: :any,                 sonoma:         "3277ee53a4bf80e5a55c39b3542a8ed1d061da640f0aa287f50b406d6b840417"
    sha256 cellar: :any,                 ventura:        "3277ee53a4bf80e5a55c39b3542a8ed1d061da640f0aa287f50b406d6b840417"
    sha256 cellar: :any,                 monterey:       "3277ee53a4bf80e5a55c39b3542a8ed1d061da640f0aa287f50b406d6b840417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eb64857a3ab95c916c17ff2a5bfdca8e52e9dc6eeb68210ad8ceee4632450bd"
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
