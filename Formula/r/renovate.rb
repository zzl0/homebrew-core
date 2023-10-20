require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.31.0.tgz"
  sha256 "f4e8341d196a3fc95b1f45ae83fda6b5ab12a57f8d1522ba87ba4e6b4edf9dee"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df861dd309e8b52efb29d3631dd38cb40cfcf960631c4878ded9303217f0fdd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27aea8af1e30d26248085726574554e049ce3d66420cd68c89f71624a83ce250"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4419c851240fbeb745b9869458d4de031611811dfa78ab97c0ea340361a44425"
    sha256 cellar: :any_skip_relocation, sonoma:         "af5ab78ceaba872eee74e65a72e6d81bf4b509e44cbc558556ee295554e7c71d"
    sha256 cellar: :any_skip_relocation, ventura:        "1f2c544ceed3136887d5bcc272fd8e64a993f0cc720368efe561c59442241b3c"
    sha256 cellar: :any_skip_relocation, monterey:       "b7cf7597c198cddd8b08483747eb0f60e990e02645f33b0c923cd18845f21536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7d2ecd51084ac3013b39bd06d05fe45e2ed0a3d3f5b6ee3bd94fb359a6d8eeb"
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
