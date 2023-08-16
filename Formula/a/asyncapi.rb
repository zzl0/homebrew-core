require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.52.4.tgz"
  sha256 "3009f492cf019287d8ed90009d26650470ee5a32c579be433bd503e0d279c8dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "634ff00a5a286500ec7342504b8e9fa65a5caf521d1d1ac0b9773c177c9bc786"
    sha256 cellar: :any,                 arm64_monterey: "634ff00a5a286500ec7342504b8e9fa65a5caf521d1d1ac0b9773c177c9bc786"
    sha256 cellar: :any,                 arm64_big_sur:  "634ff00a5a286500ec7342504b8e9fa65a5caf521d1d1ac0b9773c177c9bc786"
    sha256 cellar: :any,                 ventura:        "533c3837327cb59625860b17e437e5076fece34522dbe2fdf9d2237551430ced"
    sha256 cellar: :any,                 monterey:       "533c3837327cb59625860b17e437e5076fece34522dbe2fdf9d2237551430ced"
    sha256 cellar: :any,                 big_sur:        "533c3837327cb59625860b17e437e5076fece34522dbe2fdf9d2237551430ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a1f328d43c0652a5e9dce3358ac9f329234c4cb3479f09e763e61e31b9c6485"
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
