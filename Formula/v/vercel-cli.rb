require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-32.7.2.tgz"
  sha256 "ec395707e660b3fd0d6e8b527a907a05c09df6db1d65b520cebe50ea00203d11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b50a43902b5fa393f2a33d733fa16227548db0170370b06e11e8c687bd0bfa1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b50a43902b5fa393f2a33d733fa16227548db0170370b06e11e8c687bd0bfa1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b50a43902b5fa393f2a33d733fa16227548db0170370b06e11e8c687bd0bfa1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "76794f5f2f69bb0d795a0c61e9383582ae4a51d1d982121f1e55507b764385df"
    sha256 cellar: :any_skip_relocation, ventura:        "76794f5f2f69bb0d795a0c61e9383582ae4a51d1d982121f1e55507b764385df"
    sha256 cellar: :any_skip_relocation, monterey:       "76794f5f2f69bb0d795a0c61e9383582ae4a51d1d982121f1e55507b764385df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06e87fe8a094d9518fe4b93bb63e8bdd4532316a0f4f8f118ea516c6bec46608"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    (node_modules/"fsevents/fsevents.node").unlink if OS.mac? && Hardware::CPU.arm?
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
