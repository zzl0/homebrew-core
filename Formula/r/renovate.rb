require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.87.0.tgz"
  sha256 "206a565ddb31667ba1f1c097d134a7ec589ee0f3a94c9ef1615d3fefb0ffb731"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d6e13450a3e579f91855c4961b2fea923ce7a79cc9f1452832ee02037939f0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f2e848947aa179bb614875713d3815f417422bc95052eb884cac047a585435c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "255cad6429447e81de6ba7233d5264478f767625a545548f593d54e545362610"
    sha256 cellar: :any_skip_relocation, ventura:        "08f14aca6d9ebb687ad4a9063d3edb430a2d7d27d4e62b293b50192c85ea903d"
    sha256 cellar: :any_skip_relocation, monterey:       "6a49a8a7890859d4acb16a95155c7d9ed1c4de5cc7f249b0ed8295e8a92a8611"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5f6ad959e9b3951a6c853aa4b345f2900dfc6263fa4314986d206b73add719f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d45752a89ecb397097d2470c957c782220509e211fadfcafe41245328c60a261"
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
