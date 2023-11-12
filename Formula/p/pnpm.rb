class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.10.3.tgz"
  sha256 "eb2548d6347afc7002a046b7be3ee3c8222bc71f68418dcf9f90fa0a7341c41a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad386a363cd440623ca299dd708924be9976e20e318dbb71e19ce60e4216b84f"
    sha256 cellar: :any,                 arm64_ventura:  "ad386a363cd440623ca299dd708924be9976e20e318dbb71e19ce60e4216b84f"
    sha256 cellar: :any,                 arm64_monterey: "ad386a363cd440623ca299dd708924be9976e20e318dbb71e19ce60e4216b84f"
    sha256 cellar: :any,                 sonoma:         "267e84ed0beb54273343a02468dd9591ed6d960746a26e71bdcdda9912b36949"
    sha256 cellar: :any,                 ventura:        "267e84ed0beb54273343a02468dd9591ed6d960746a26e71bdcdda9912b36949"
    sha256 cellar: :any,                 monterey:       "267e84ed0beb54273343a02468dd9591ed6d960746a26e71bdcdda9912b36949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a7c95d15958c15885b29ebd07bef46b2607a6610c5a2e89871f2121a2c5808"
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
