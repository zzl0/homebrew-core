class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.7.6.tgz"
  sha256 "c95869d443ed8fd6b7bb164bb8e89b56cabdc24f3c79b87ef68d8ae1c6b1d0e2"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bc5fc6decd8d1091ee28e78be62463cb0454108ce2613b3f6ef0262adda4be8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bc5fc6decd8d1091ee28e78be62463cb0454108ce2613b3f6ef0262adda4be8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bc5fc6decd8d1091ee28e78be62463cb0454108ce2613b3f6ef0262adda4be8"
    sha256 cellar: :any_skip_relocation, ventura:        "4919bfa79eb73a485c53ddb2672cddd2ae193821dd782f6ce7883970138b9b1d"
    sha256 cellar: :any_skip_relocation, monterey:       "4919bfa79eb73a485c53ddb2672cddd2ae193821dd782f6ce7883970138b9b1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bb1305e1b356a074efd2e63b22dd628105eb780b7d5b1cb43d82993da1e599c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc5fc6decd8d1091ee28e78be62463cb0454108ce2613b3f6ef0262adda4be8"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
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
