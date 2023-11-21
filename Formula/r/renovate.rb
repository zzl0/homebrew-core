require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.64.0.tgz"
  sha256 "34feebd766ef66b7bfa8af721f19efbdd414e4cdc5d9b62f047d4dd94485721d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33dc4fe480b4f090342945452b55aa23ca5dcbfe7ed2b2126c99c2f9fec82ed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58055120f395efb77f988ce9f6140e835514f9c177a771d67e76b292bf46b439"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00adce793ce0657a3f8a7636cfc3d509273aebfa7b4769ee4df92ad3370f5306"
    sha256 cellar: :any_skip_relocation, sonoma:         "40a655be1ed86918043e929c59418c75a4831d073c124cdba22383611612ec59"
    sha256 cellar: :any_skip_relocation, ventura:        "90397949f555bf29739e837f31fcb9d1f7f244fa235af1cec687fa03d262eef8"
    sha256 cellar: :any_skip_relocation, monterey:       "a34a8552c12d7a57dd737b47e58859d1f90803a1510d17439b549223550ddc67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee8ed8d0e248682b87933be981faa6a309ca2855574c3e93b6968fc72c919c9d"
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
