class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.10.5.tgz"
  sha256 "a4bd9bb7b48214bbfcd95f264bd75bb70d100e5d4b58808f5cd6ab40c6ac21c5"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e3b09776ab612ba9755a43da6cf0d3359b222471602d87ba4359842f1ecc5750"
    sha256 cellar: :any,                 arm64_ventura:  "e3b09776ab612ba9755a43da6cf0d3359b222471602d87ba4359842f1ecc5750"
    sha256 cellar: :any,                 arm64_monterey: "e3b09776ab612ba9755a43da6cf0d3359b222471602d87ba4359842f1ecc5750"
    sha256 cellar: :any,                 sonoma:         "62c61efdf6e41c4d06fcad419b9cfd434128083698e195a97050f5f3e8b4d6a4"
    sha256 cellar: :any,                 ventura:        "62c61efdf6e41c4d06fcad419b9cfd434128083698e195a97050f5f3e8b4d6a4"
    sha256 cellar: :any,                 monterey:       "62c61efdf6e41c4d06fcad419b9cfd434128083698e195a97050f5f3e8b4d6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d331ebd6a4d0784ec64dd09d645738ba6658edc3544a5a6870a008fcd0f73f"
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
