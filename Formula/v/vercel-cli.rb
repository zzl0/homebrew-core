require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.1.0.tgz"
  sha256 "862cce0a732d2e90371e280dcd8f21df2d5d904719c62ee86cc434de731dfe31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7a505a9bc4721209d4778cd4d95c128f7114b05f242d46146d50d4c60bdd407"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7a505a9bc4721209d4778cd4d95c128f7114b05f242d46146d50d4c60bdd407"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7a505a9bc4721209d4778cd4d95c128f7114b05f242d46146d50d4c60bdd407"
    sha256 cellar: :any_skip_relocation, ventura:        "02b2c67097b79125e7f3a90e040b37baeb006af8a8c35e2879e125164df97fc8"
    sha256 cellar: :any_skip_relocation, monterey:       "02b2c67097b79125e7f3a90e040b37baeb006af8a8c35e2879e125164df97fc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "02b2c67097b79125e7f3a90e040b37baeb006af8a8c35e2879e125164df97fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1f49359e7048fda3046e3bf2b7b082c1ce6c9d712b7bc7c5ec377656b33c49"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
