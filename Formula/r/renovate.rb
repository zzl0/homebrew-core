require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.23.0.tgz"
  sha256 "9ab1b94b3d3955c743127df93ef87ff34a0e89999bafd69a4b603a733fbc02f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24d1ac004be69a6198790c4a86e899aa64fcffdd4a246e09fa082f00d010eed7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1e398d2398a6353622c6989df00750aa62936e14ae76457c60c896528e0d94f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b5a3bb161df7b790954a7782aa9af2fa46369e027c64c3bbfa455426dcb627b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b28c3ace228a3dcb3ebe0289363a039769cda1f4180196357030324ca38455b3"
    sha256 cellar: :any_skip_relocation, ventura:        "7269bca6d49fa5763db3d5722e39c787e905641e850d406b23cde8db3b9ebf5a"
    sha256 cellar: :any_skip_relocation, monterey:       "95c33ce355381093edcd74e06b204662749965cfa04e6516eba3613efab739f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e656f7340605412dea9e5ea7c72a5286badbdbc77b9cb0fb2c42168330dd89d1"
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
