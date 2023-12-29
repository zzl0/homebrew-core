require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.111.0.tgz"
  sha256 "79f7d6c9c5fde6b5ca2ecd3851b1539380bbf562f6b123a218fd828ffb574bd9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb6c095cc1c0d63e6d717478eb4f68cf7cbfa2021e7ef8a934650a559277a881"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73552c11460626249c9c30c586ab5d9814b100f2efefcdd3d0214374f3412518"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12bb3c8cf6ecd32df92f55ddbc1128123bdad07b2f305da8c58d57c3d2f5917b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0efcf06aa818472cf3cbcc877fe3e2e1783caf22f7eba057f44e63561c5bac8c"
    sha256 cellar: :any_skip_relocation, ventura:        "eaf867df9a22663ced11ce1d488d947534d7d8a735c565b40df767a78d8c0df4"
    sha256 cellar: :any_skip_relocation, monterey:       "dd845af23706fefd893f1bc734a8f1facccdc891db1edf7de2eefeca4742678a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d0392dd2ece9ebbd9bece3b50db42a2d29be6fd7989d00edcd0237cb8081cda"
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
