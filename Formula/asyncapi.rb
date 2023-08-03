require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.51.12.tgz"
  sha256 "c6e024d00c610f0130e16bf6bb0ebdb5b27466046f8e1f6c444003710b7c2a1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8abbac430d2e29d3a593dc77ee284cdfcdf54b704574a7340a72db074fda1d60"
    sha256 cellar: :any,                 arm64_monterey: "8abbac430d2e29d3a593dc77ee284cdfcdf54b704574a7340a72db074fda1d60"
    sha256 cellar: :any,                 arm64_big_sur:  "8abbac430d2e29d3a593dc77ee284cdfcdf54b704574a7340a72db074fda1d60"
    sha256 cellar: :any,                 ventura:        "4dd93e33bce85a0803e6466c5b6414c2667c602bb0891e2d1766d82ce0ef48e2"
    sha256 cellar: :any,                 monterey:       "4dd93e33bce85a0803e6466c5b6414c2667c602bb0891e2d1766d82ce0ef48e2"
    sha256 cellar: :any,                 big_sur:        "4dd93e33bce85a0803e6466c5b6414c2667c602bb0891e2d1766d82ce0ef48e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb4f0fb799e90bbf17f3607b2da0174d33667d2f8b4d03497190c61228af4a7"
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
