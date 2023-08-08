require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.38.0.tgz"
  sha256 "275528214183bff3f1ecb0a1958d38d387a81224d0bce48c386f72b7b5e9d67b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee6eccc4d29379a0982b91e6234075ee058be0bb96f3ca3bf68a840f891c7f40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc2a121d6a590c124c7e9649f86547be3a8795534bfd2ab86b9d29f7e92cb0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a66babd45bbb41fb293ff0c214fd5e4f99d38ec564f5ff4343bb6cfa9913cdd"
    sha256 cellar: :any_skip_relocation, ventura:        "1094220dc6f3343c99f7c760e04734e4c389a9fc7348902006845368df003c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "5c413b6b949eee82565ed5e8e649737b9398ad12a630b8dbfe98364b39726162"
    sha256 cellar: :any_skip_relocation, big_sur:        "a98e90befb6866bd96a3a3ef9b83299ca849a2f9b8c900eb0316f54d9785a078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66493250cca5c56d97e1943abfd1f2847e38bbb3ff7a2b717645c4b96700480f"
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
