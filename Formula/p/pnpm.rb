class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.10.2.tgz"
  sha256 "487609e857f1c11780cc98dd0bfe4c8a8b11c7f23bc3a4493ac7d263d6fb6c8c"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d21d278a9d86b6d3c479dca5b10948624531a1984191f04babcf9ff6bb0e1727"
    sha256 cellar: :any,                 arm64_ventura:  "d21d278a9d86b6d3c479dca5b10948624531a1984191f04babcf9ff6bb0e1727"
    sha256 cellar: :any,                 arm64_monterey: "d21d278a9d86b6d3c479dca5b10948624531a1984191f04babcf9ff6bb0e1727"
    sha256 cellar: :any,                 sonoma:         "28b929135e3831256200d6814f0d00642dd4f2e1bec629ad9df5366a44a2532d"
    sha256 cellar: :any,                 ventura:        "28b929135e3831256200d6814f0d00642dd4f2e1bec629ad9df5366a44a2532d"
    sha256 cellar: :any,                 monterey:       "28b929135e3831256200d6814f0d00642dd4f2e1bec629ad9df5366a44a2532d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73b81f3b4db7950bfb14303f5fa2811eae508b22c872afe07e6a5b528acd40d5"
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
