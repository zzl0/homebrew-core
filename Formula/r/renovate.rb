require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.102.0.tgz"
  sha256 "f97fcdb351de51b1cc10da064759899bf191ab2c94f7df2ac742dbf86add93c1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40f6810486fce939c3fc39358203dfce658cf996d8404b2f9865b923df46cb10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74ecb20704b76172e14a1af3ba1dac464df6c669bdbebe6a1ce1797d93504d48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eace42b6599d0c47dec0283a049f597afa4369679130893ab1cad1eccbff1b06"
    sha256 cellar: :any_skip_relocation, sonoma:         "86ff38286d62c86cb37a1b06fe996f76871de2633bd5f9e57d83bac1229a0ccc"
    sha256 cellar: :any_skip_relocation, ventura:        "c916d0aacd29c26d17b9881458c95a9faeec8e91783145c39bf089a357e8bb5c"
    sha256 cellar: :any_skip_relocation, monterey:       "6765a4c4109b63fbd678cb19b93f133936d583c471e19ac87976ed2eff51e31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adc38e1697cd088e9edfaec8ae0e1ad2ca00acc879ccb07cbe9dbd59172ef8ca"
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
