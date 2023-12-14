require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.96.0.tgz"
  sha256 "98d537d86efb610f6ff5f765ac9c13f886caeed5099451365103e195b6c2c4f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd4a8b214415a8b279d39838a17c4c0ef4c62ebec0b9b2db380569a33582f76d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04b6221dd5e7baaeaa7c18101e8c24a9fa63be8bcbd0cc6b09abde03ff07128e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8130c1727394d8b628bedbbe4b9b6797634b475a106ec187308866d1b11b1778"
    sha256 cellar: :any_skip_relocation, sonoma:         "2075b8910a0fe506d69ed56926b7d7610d017a0c5d1305ad58b11c7ed7b1b068"
    sha256 cellar: :any_skip_relocation, ventura:        "c7026079d13889363e0275f167dad0f99887245cc0b1faea13cc5e5740ead1a8"
    sha256 cellar: :any_skip_relocation, monterey:       "a08a8a40e05954e8a961b02acda9a899f21ca8b70aa1c4ed14de1378b7f2d776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cbbfa552f71e3b44e24d8d11a5ef159dabfb48fb7b070b3e0a3c7521ddaf771"
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
