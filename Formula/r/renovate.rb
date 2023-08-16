require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.46.0.tgz"
  sha256 "e562a10c9d0e265d4da27467e58d9c99a494f71f156ef44218b28ec353a9e727"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "429dc526c3ce0bbfedfaa0f19bc9b24334e10a4c78797ba42ba4619e4969b767"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0b52795a2528636f0ff01e56c735bc0a94b23af6347e0e9f1863efde1073aad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "497a5e828d78c250b787f6b03513b323032573693914287989cc6c1c85ce302a"
    sha256 cellar: :any_skip_relocation, ventura:        "59f89fe4b41624a99334adcfed1e4c26dc3db66d16fa12b189e0750c8376664c"
    sha256 cellar: :any_skip_relocation, monterey:       "b792a6b338f881b81812f505789e2be36d105fa0053b592f6b768304995e0294"
    sha256 cellar: :any_skip_relocation, big_sur:        "272ab2b2b3e6cbfd873a8e574c2ea9444a294faa61ef92a3f1d46c224d24cd20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa5ab465926fa9efbbd57b44b1396c56314d7d01ca578e5d38f8426dd39639fe"
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
