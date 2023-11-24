class Pnpm < Formula
  require "language/node"

  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-8.11.0.tgz"
  sha256 "5858806c3b292cbec89b5533662168a957358e2bbd86431516d441dc1aface89"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89be7a2cad9eabebaa0596c9d65e67f26c37a771bdbd8e6387c633f10cfba7c8"
    sha256 cellar: :any,                 arm64_ventura:  "89be7a2cad9eabebaa0596c9d65e67f26c37a771bdbd8e6387c633f10cfba7c8"
    sha256 cellar: :any,                 arm64_monterey: "89be7a2cad9eabebaa0596c9d65e67f26c37a771bdbd8e6387c633f10cfba7c8"
    sha256 cellar: :any,                 sonoma:         "2099c82ef350bf3479e1aeb29ee849a6c8053f3a171129466e2281020cff0b4e"
    sha256 cellar: :any,                 ventura:        "2099c82ef350bf3479e1aeb29ee849a6c8053f3a171129466e2281020cff0b4e"
    sha256 cellar: :any,                 monterey:       "2099c82ef350bf3479e1aeb29ee849a6c8053f3a171129466e2281020cff0b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d168a9eed6cf8bd5abaa7c34931230aece6d83efc2835d144b3bb324365c2fc0"
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
