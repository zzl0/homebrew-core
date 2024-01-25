require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.152.0.tgz"
  sha256 "906ed2d3a17c9933b9e8cf8362d75dae6e11694be4219c3e791842e59be66547"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e80af59bc3a5c8f39aced826966133d49214f43c626690741a257b7c8c550cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a20601133aaf18eb472f37d637feac61d0cb283265f79a9a876bc0a076bc4cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "829a35bedd07dabf86ae805024c1408cebf2e9d81e4ca656e22250e75145e417"
    sha256 cellar: :any_skip_relocation, sonoma:         "8daaccf9ca9b69502e16bf16f80b100bfe74d9113e5bec37e8e9e9c80ff6e125"
    sha256 cellar: :any_skip_relocation, ventura:        "374f42142a053e044775232fd075c2b24818fb5c1c5275a0e55840c20f380ae6"
    sha256 cellar: :any_skip_relocation, monterey:       "bf364fc397b5eb19b2f24e591a981fcc83d1b66f9f1182a9a778b1534aec6260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f51ff67d1c3e56733c4941210a1665c03e3f7b266ec33d0833285463eafe7dd"
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
