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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c6c645c228495dd0ece7b8b67fe59b8e1eb4675d9fe099354dc4900709118f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adae3a95a8d387c63fd2d558226670fa7dd7929adafef8e7641e6aab97f89366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab6de709299de9fc9a58219ba5dc7c8357be72ddc35283313bc558b123ec2b48"
    sha256 cellar: :any_skip_relocation, ventura:        "4f8e36a7c05b80fdb6e7cab4e1ce0fb28f40d2e3cead06f9a58a321b75145067"
    sha256 cellar: :any_skip_relocation, monterey:       "875c854ad8bcb4a7daaaa940806978b4f9533e251658508c4ac2cf2dc628af5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "344a91eb0a88e5643be656ae281ec337201c21a79029eb3f5f6118622713e485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85deba7cfd1f762dde7f4258cd0e58f7af97408fb2e3f4b40f9f83b617a9788f"
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
