require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.32.tgz"
  sha256 "ba62ca1d6942408586c55c48391f157b7bde92390c4b3d166d3e17b342ee8f5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8b1966936ac6130b32c004253b12d624f920a496666d7154fd5ff34e2bdf4b2e"
    sha256 cellar: :any,                 arm64_ventura:  "8b1966936ac6130b32c004253b12d624f920a496666d7154fd5ff34e2bdf4b2e"
    sha256 cellar: :any,                 arm64_monterey: "8b1966936ac6130b32c004253b12d624f920a496666d7154fd5ff34e2bdf4b2e"
    sha256 cellar: :any,                 sonoma:         "d13149ee5ff7b14f9a455665031c5559bef95e4e06608422824ae90f43af4033"
    sha256 cellar: :any,                 ventura:        "d13149ee5ff7b14f9a455665031c5559bef95e4e06608422824ae90f43af4033"
    sha256 cellar: :any,                 monterey:       "d13149ee5ff7b14f9a455665031c5559bef95e4e06608422824ae90f43af4033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "390e5b95e490ac037245cebaebe749d51ff05725117b867271df6e4eeff1c271"
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
