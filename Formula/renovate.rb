require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.37.0.tgz"
  sha256 "6f7a0c4115d1201fe3349f68227b075aae0ceb16caceb3f46b68a61d8158bc28"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "345c4076be2306737967a7725df68815b413251d5a96d4128bebf5be026174f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "863ac77b2e6c0980bd94d581fd5b1f082206206bfd8830ce2253167a824efb63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b783014d5f34b01b120fe0d35a2da7ab92e3330af5a775a6773ba1e49c35414"
    sha256 cellar: :any_skip_relocation, ventura:        "9064feec17750c9245f73e607d96eda7ed4de2f929770a853b019bbddbeb0197"
    sha256 cellar: :any_skip_relocation, monterey:       "8c0874f0a79f3eb3bab10068bf59f74da5ee0eebbd1a091ae33774e046fe03e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "32f2b5cc60a6a03a189ad1e63d6994d781216d18ebfaf7d08f0d6842c646df3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb62ab333654ef06845bffd01b37b23d51768879b8415d8ec1330dde4149001a"
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
