require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.56.0.tgz"
  sha256 "649d3f867748cd5c7584430adb39d364b5bacb574619464e065d27505fb165a5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f0bde768dbb21795e3ae3e236c376002ec96039fad312024745ff4cef68153b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d91040ae91d3f9a9b2a276a78d934e57e0885bc8959cffa040f981ffdd37617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df633f2e5a473f2447619d59f641b5964bfb85da4c16648cbfbc4b8ab3103f47"
    sha256 cellar: :any_skip_relocation, ventura:        "51f1205c9fd04ba8e648ae81f9b2824fd1fed2e525c05a6838e768403a130d1a"
    sha256 cellar: :any_skip_relocation, monterey:       "2321ee7f42ebacdc89b265185d12a8e2ad4431e3162780e2d75d99c931e5e7c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d293c66f4be565175da1599b6377d2386eeed9cfb2c2e6771eecdb690a85314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63c649a9a953cd5c2741acba22fc866ac6d13444836c60817f56af2602b0ded0"
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
