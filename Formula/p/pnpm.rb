class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.7.3.tgz"
  sha256 "672482301c0ca3f0ac1ae58c0a564ea3720b39a15e13826aeed4b7a8867a309b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c09f38cc893a3b2501adb53cd57116c724b05ab152e4dd924170f1663449354"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c09f38cc893a3b2501adb53cd57116c724b05ab152e4dd924170f1663449354"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c09f38cc893a3b2501adb53cd57116c724b05ab152e4dd924170f1663449354"
    sha256 cellar: :any_skip_relocation, ventura:        "704edd1b951902dc4a8dc560f64a3c953b366dfddb24cd1c8227909daf376a94"
    sha256 cellar: :any_skip_relocation, monterey:       "704edd1b951902dc4a8dc560f64a3c953b366dfddb24cd1c8227909daf376a94"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee7e8279dac2293f1e81d43973ab40f858fd9b9eee7eaf12ca9870641815ed3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c09f38cc893a3b2501adb53cd57116c724b05ab152e4dd924170f1663449354"
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
