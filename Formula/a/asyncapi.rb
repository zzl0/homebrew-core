require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.4.3.tgz"
  sha256 "1e494eb2fa98b8b747cd7dc16df490d04d1e3f3fd8520507e98d4e2eabea2818"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d9520e1fa056fcb3dd7d6034a6688007637ff9e7283281c03f5f8b8a0ff5737c"
    sha256 cellar: :any,                 arm64_ventura:  "d9520e1fa056fcb3dd7d6034a6688007637ff9e7283281c03f5f8b8a0ff5737c"
    sha256 cellar: :any,                 arm64_monterey: "d9520e1fa056fcb3dd7d6034a6688007637ff9e7283281c03f5f8b8a0ff5737c"
    sha256 cellar: :any,                 sonoma:         "bbdf031d99b34b4ccc071db42433237157ac7a4192f811684eae53de3e45455d"
    sha256 cellar: :any,                 ventura:        "bbdf031d99b34b4ccc071db42433237157ac7a4192f811684eae53de3e45455d"
    sha256 cellar: :any,                 monterey:       "bbdf031d99b34b4ccc071db42433237157ac7a4192f811684eae53de3e45455d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "648669f45a554e3162efe0d49b3af429212323a0e97ca77de87240008967e792"
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
