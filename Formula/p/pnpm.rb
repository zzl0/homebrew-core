class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.9.0.tgz"
  sha256 "8f5264ad1d100da11a6add6bb8a94c6f1e913f9e9261b2a551fabefad2ec0fec"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9677d2dc4e1aef473ef6f4fd0a002707fdf4ca97084946f849a093cd2dfd54ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9677d2dc4e1aef473ef6f4fd0a002707fdf4ca97084946f849a093cd2dfd54ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9677d2dc4e1aef473ef6f4fd0a002707fdf4ca97084946f849a093cd2dfd54ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "da5585f04a37c153ce69ebb86ef0031b896036c968c4a1f09ae549b9ecca6fca"
    sha256 cellar: :any_skip_relocation, ventura:        "da5585f04a37c153ce69ebb86ef0031b896036c968c4a1f09ae549b9ecca6fca"
    sha256 cellar: :any_skip_relocation, monterey:       "da5585f04a37c153ce69ebb86ef0031b896036c968c4a1f09ae549b9ecca6fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9677d2dc4e1aef473ef6f4fd0a002707fdf4ca97084946f849a093cd2dfd54ac"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"

    # remove non-native architecture pre-built binaries
    (libexec/"dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
