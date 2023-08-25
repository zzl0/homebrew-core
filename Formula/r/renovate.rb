require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.62.0.tgz"
  sha256 "bc6c091e571add117cecc384dd71307dac08e88ff2a3d91b39b9cbad2c76bb82"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28d1044ae41a8b8eb0f81467bbcce580f901e9498a0819c75ed0576021e6078f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09de0241adb5a4b5574ef590e4bdffc0f4493e9f9705745e5416cf97bc288b9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3d0a834a241106a01162b242162f36ef8a1542e012a8e469a2f70328832bef3"
    sha256 cellar: :any_skip_relocation, ventura:        "32055aa5ac3e1265504e650fcf42d39d89ac4b4f7cab7e69c03fc9fc7426ab10"
    sha256 cellar: :any_skip_relocation, monterey:       "58132d97cf8fff1d834f482e4e176ceb0add309ce4ed9bf5fb6827b9dbe3495d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2371ac9a8485a10e32b5c5df07b67878870e878d5cdbef89039fdd76301f9d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edbeaf5aa63c67b1e7419beb5187105f7a39cce701328355e0289adcb3cdddf9"
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
