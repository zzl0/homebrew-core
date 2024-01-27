class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.15.0.tgz"
  sha256 "fd1eab68a6d403f35cf3259c53780d70b0f14bd74e39da2f917d201f554d8665"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "41b1e9a60f011c2e05f63b2611cb638e7d21b076f397679094f3e85d2822441d"
    sha256 cellar: :any,                 arm64_ventura:  "41b1e9a60f011c2e05f63b2611cb638e7d21b076f397679094f3e85d2822441d"
    sha256 cellar: :any,                 arm64_monterey: "41b1e9a60f011c2e05f63b2611cb638e7d21b076f397679094f3e85d2822441d"
    sha256 cellar: :any,                 sonoma:         "28ee58c34f68b47ea1f878dbbd36317021ceaa1f8517255536a3cd329ff34953"
    sha256 cellar: :any,                 ventura:        "28ee58c34f68b47ea1f878dbbd36317021ceaa1f8517255536a3cd329ff34953"
    sha256 cellar: :any,                 monterey:       "28ee58c34f68b47ea1f878dbbd36317021ceaa1f8517255536a3cd329ff34953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29b189b85cc86ebc650c0bbdaa6f764e2ccb82383560f77e3fad736b352790df"
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
