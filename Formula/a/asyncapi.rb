require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.25.tgz"
  sha256 "b7d1c88cd763271fb2d232f2556b7e3b16536ff32305e385a3bc4368b0f6922c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87e05947a1c034f07a0d0410eda08b9f01e8786775b12e1239dd7e79c30fbbff"
    sha256 cellar: :any,                 arm64_ventura:  "87e05947a1c034f07a0d0410eda08b9f01e8786775b12e1239dd7e79c30fbbff"
    sha256 cellar: :any,                 arm64_monterey: "87e05947a1c034f07a0d0410eda08b9f01e8786775b12e1239dd7e79c30fbbff"
    sha256 cellar: :any,                 sonoma:         "6ba1f2bfcfebf556716c901de931c92c87c645d8ea478bca61ee49f27225834a"
    sha256 cellar: :any,                 ventura:        "6ba1f2bfcfebf556716c901de931c92c87c645d8ea478bca61ee49f27225834a"
    sha256 cellar: :any,                 monterey:       "6ba1f2bfcfebf556716c901de931c92c87c645d8ea478bca61ee49f27225834a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b336188abd9cb2c69e8748e9788e2055d44934c63a3f94316db85fc4927e78a"
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
