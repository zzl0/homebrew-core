require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.65.0.tgz"
  sha256 "090f4f50088f070d9789f5110f7f515f21f6e32aaad70b20968a01561cad3e68"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8775a00791f20fc63da76c32051c6f2103c35c363b15e1bf08b4905c97789e61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4627e68b949da02c18974699def734e79789cb38d596fc9281d85d8a3ba3bf0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3075274b7dafcf51d917612399c0343c9f98d34919d509c274d3728bec004db"
    sha256 cellar: :any_skip_relocation, ventura:        "068b983fea459675799d81821569026694ad2cd7aa43194fb71e9a6c23036b3f"
    sha256 cellar: :any_skip_relocation, monterey:       "be8021bed98eb7c65862df7e76e95d9cd4bc2744b61d19e9a30f0fc8d7048db4"
    sha256 cellar: :any_skip_relocation, big_sur:        "75a461ad8b41101c4733e7e9390997ea71a6874a82629fc61dcf34f622c2f54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22dfa6b1cf8b184bf961a358adea05b4dca1cb1880c3e8243995d21b227a1231"
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
