require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.110.0.tgz"
  sha256 "328502879ee74eaf733e1f795dc7b23c01ffc74adb73c608a16519fc23ba15b1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7a98cf01276a8384c392f72832d1e2a04a417e4e2674b15385f1ba323740e95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8fb14f3de6272e66393cfaf19a627724dfb6297810f6fba361e68a09788f231"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca6fb64454ce44e7ff70892ca0eedfdd10eeb32ea17f6d1795850c766f6c3a82"
    sha256 cellar: :any_skip_relocation, sonoma:         "33fa2383b2a9a61ab02cc1f49652f39e5794eef368a5f48beabffa0fb1baa631"
    sha256 cellar: :any_skip_relocation, ventura:        "cd677bb63ea321cce7d9ee2327e21344339ba08236885562550ff2b411d3d159"
    sha256 cellar: :any_skip_relocation, monterey:       "19fdd4ef1d2de43e1734f7147ccdfb735af69a09a4a43f47a5ca7461ebf1a17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c19218a8a194ef41bfcbc40c351db7810288f37de4da5e65141e5ee6f2131f"
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
