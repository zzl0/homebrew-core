require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.176.0.tgz"
  sha256 "0074faa12971f17168f5380c38c92e1d8830b60f8efdae9838c07486b222483b"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cdb583abee9accff024021b63cf7f1ca143a72b54038da40efd91b602450e24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8b435f88ca302f24e0886bcce8678075968955386d8c022105d0ac7b0aa96fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cb14879be9675e16796523a790748ba728b379f3faf29516e134b851b5d5382"
    sha256 cellar: :any_skip_relocation, sonoma:         "69700f976f985984d22daf19c9ad0d03e7a390c1c8f5572cc7837c193ea5ae3d"
    sha256 cellar: :any_skip_relocation, ventura:        "9699b1ed26be35cf7689477d2409d7e7817718ff7e63f17075c2acdb650bd77f"
    sha256 cellar: :any_skip_relocation, monterey:       "447195656e751d2a1150bdd598ce8660a2d801a91883655ae80be384753ab589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca9f8d752fb9ec6ef181e11287b505b5b388ca45a51522c3e1b16938801254ce"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
