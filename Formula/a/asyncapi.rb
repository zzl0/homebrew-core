require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.56.1.tgz"
  sha256 "572b7e0df2e12b25554ed1937351d1a6cba33fc2b0258e941a643edcd166d767"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1153d5babdc66e28525a5b8d1ade3d0d62aa8a3a36b6c7287194f067d829612c"
    sha256 cellar: :any,                 arm64_monterey: "1153d5babdc66e28525a5b8d1ade3d0d62aa8a3a36b6c7287194f067d829612c"
    sha256 cellar: :any,                 arm64_big_sur:  "1153d5babdc66e28525a5b8d1ade3d0d62aa8a3a36b6c7287194f067d829612c"
    sha256 cellar: :any,                 ventura:        "7c0e7adfad3eeb637e982d173f8fdf9ac34b6d58e95d5f1887821c2b09309f3e"
    sha256 cellar: :any,                 monterey:       "0d2313374452683ca073b4a0c58909c6ed45f42ad401a58451a289fe8b3608a4"
    sha256 cellar: :any,                 big_sur:        "0d2313374452683ca073b4a0c58909c6ed45f42ad401a58451a289fe8b3608a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73421df657f1f91fbabcb05986bfa8ce74c5a0f1599eb29356eaa71478e8c2d9"
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
