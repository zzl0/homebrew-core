require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.56.0.tgz"
  sha256 "4ac308893d537b51c3d36804d48cac9751e24b7ebf57c83dd7a21abe12295041"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a141aed780340cccdb4dbd95e442aeb3e5c73e34b1e10eb3958b46f082073a17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3705df0583a9fe73080d547582e6ec1fecc8af4c217919a6267bd7e38faf8a21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92ac3b1bd614b2d25cea28e8120bfd8ed7c3048a93e675e3dc87ca9b3e6f87c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a44b6c5066f60ba1ff41218750cd921842c9b6bbc4a037a1c0a047c21ff014a9"
    sha256 cellar: :any_skip_relocation, ventura:        "30ed390d4fed11b12b189e45c0144afbce8176b95d6cccc3f783b2d18b5bc2cc"
    sha256 cellar: :any_skip_relocation, monterey:       "25464807c1b83482728622be8c56826fa417d52e0b0dcb1bd8c8df518d55de79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c37bed03e1daf9ff4d843e4f27a245b50acecd5324ff825f80e467612f15aa3"
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
