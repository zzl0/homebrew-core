require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.19.tgz"
  sha256 "305efccd5a37016838ca6dc0fb59e3915402f3002f8d2935eeb138857443ce8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "12b424deb9cb097e22fcdc4106e88f277eed8321d0aba9dbe971d2bb3f10523e"
    sha256 cellar: :any,                 arm64_ventura:  "12b424deb9cb097e22fcdc4106e88f277eed8321d0aba9dbe971d2bb3f10523e"
    sha256 cellar: :any,                 arm64_monterey: "12b424deb9cb097e22fcdc4106e88f277eed8321d0aba9dbe971d2bb3f10523e"
    sha256 cellar: :any,                 sonoma:         "fabfe6d4bbde975daffd87815c4804cff72256dc5e0fb1b445f4a026810e9f3b"
    sha256 cellar: :any,                 ventura:        "fabfe6d4bbde975daffd87815c4804cff72256dc5e0fb1b445f4a026810e9f3b"
    sha256 cellar: :any,                 monterey:       "de031b2c882367ad6bc1a0e55bd035486e7b4350dc60abddbb27f65734b904d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35ef6d886ad8f99642494a64da0660f51de0f2309b93efe3027412d4420c3640"
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
