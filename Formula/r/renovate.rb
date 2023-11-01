require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.38.0.tgz"
  sha256 "d19bf8929e7bc49df6a90946b393bf4d78759f8638172c7bbab8184da9c05552"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be46ad581764ef6537fc4b871d12fc6ec9366a74f1e8da2ddbf682d0947d15fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4bfcaca878a2be52e37784ec0e735fb834f6ecc86ea3cfea61e65adfd2b7ce1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acfeaea618fbc7c1897e8561ff50529ad95b1b8164c4a263d213a4fc6a57de41"
    sha256 cellar: :any_skip_relocation, sonoma:         "13ed03f59bb816f6f3a8e42b09a3fb20ccea9be807235f38d7e10d2abc4bbf57"
    sha256 cellar: :any_skip_relocation, ventura:        "1783a37777ec6506cf948cca5c923c0d90cc55df38b5a9e605e1f60dd39600d9"
    sha256 cellar: :any_skip_relocation, monterey:       "1bf77c637527cae5b89fec5b5e60dde7b76e25018d815b7faef62a34e1cf98e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26eff3061998da2001931fddff083cb803a70aa91dde2ca18fc6b54da85b9c17"
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
