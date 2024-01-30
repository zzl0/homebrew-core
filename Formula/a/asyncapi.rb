require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.4.11.tgz"
  sha256 "f99e067cbec1cd6c4dadcc44dd007e2c41bf11c7a86041ee3354368471a22532"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0735e84505f6ae317aa7bcb0541f09d3db68c5dea8ecc4a46b1ea4e3c608d903"
    sha256 cellar: :any,                 arm64_ventura:  "0735e84505f6ae317aa7bcb0541f09d3db68c5dea8ecc4a46b1ea4e3c608d903"
    sha256 cellar: :any,                 arm64_monterey: "0735e84505f6ae317aa7bcb0541f09d3db68c5dea8ecc4a46b1ea4e3c608d903"
    sha256 cellar: :any,                 sonoma:         "e6d1ef56b7402227d7c974027f8f0e823453d9d8fe655c9f524fd424a18297ed"
    sha256 cellar: :any,                 ventura:        "e6d1ef56b7402227d7c974027f8f0e823453d9d8fe655c9f524fd424a18297ed"
    sha256 cellar: :any,                 monterey:       "e6d1ef56b7402227d7c974027f8f0e823453d9d8fe655c9f524fd424a18297ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0932df5de9fdaece2c146325b4ec9e5d61737990951524d964ccaf7c329c3424"
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
