require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.60.0.tgz"
  sha256 "9707deeade6aad409b5d25fe8ebeb50ccd81fd01dca538cd17c32675990c8830"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c7d14933fbe6bbdbcc9036469c88944093041b4a39e4da09725473ad2fcf5ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d225ce56259b22036459b7e34e3600d3a2ffbd3609252fd7bc9d8bbec5ec664f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e63377e1921e22ccf83cae3a87c0b9b15779b477ef8d579c33e512f58196bc22"
    sha256 cellar: :any_skip_relocation, ventura:        "469b0c60865ab44fec9653fdd1766a2b9023eb8a50dad098f92ebb6570da5520"
    sha256 cellar: :any_skip_relocation, monterey:       "d4da0e77d6a007e56d25e4a28a4286e2da5f03e6c7a242ff27cbb137a27072b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3c11ce3b67a8d7befce88e5fb184e83598b880a594314713dce5bf44c2e1e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a5b769771f608b3aca995d571437a0f254f7c3ab3b45a5f124d4e1a4e50f4f"
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
