require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.170.0.tgz"
  sha256 "20e2298cdcbd2335952f7fc281e251994d2c215257ed768158e29a8a45507a34"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2d90ddf5aedb29c1de6b9c38b2ac6bd1daa9c5f3a122b8303106990a658011f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45fa85289b6a75a3177b52300ceae491ffbdcb08d50a45da8b57f62f21d97ee9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52e1c60f169d529ccf36bec1043ec7b00ac694407ccc9c4406e2c11f27327b66"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ccee33752ea1bd2e3f3f87e97f712c7bb7cf11a294d644b3390b4eab658e2a5"
    sha256 cellar: :any_skip_relocation, ventura:        "ed6404eb07200baf4b4509a1dc56907ce5abe8ee8955fb9c0408726cb1a84494"
    sha256 cellar: :any_skip_relocation, monterey:       "8afada7907de16b678b838018ccd47cf9021c90059889958ddcf1672eecc986a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204af454dbda9cfb6d080e28b7313debf9e4954a247839f0ef28ef43dfb90736"
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
