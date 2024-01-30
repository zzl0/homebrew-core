require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.161.0.tgz"
  sha256 "0affbe1a820d143207cf32d0f57f344aa439c1ecd0216a720bc325f8a5f2ae0c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f46270bc949fbf5ad8d5c9f02131f66e002cabb12b5f1319db9078c7e1d3f2a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fb87a5afb953ccb8bbd3af4d00e26fccbfd7f6bcbe2f082fe6855a22da9b263"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37f3946a6f72ce8feced080844f57fe7aa8f9186fbdfc0d1dbcf6d9b39878e5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e902ae6be467844a38329f3362c83695f590181efa8ad31767fd052d81eb4a2"
    sha256 cellar: :any_skip_relocation, ventura:        "9370eb0ff53e88351ee87d66901bfe0466a711220f12ec9fd91c8dda57544e8e"
    sha256 cellar: :any_skip_relocation, monterey:       "42e5b388bea8c2ddf270142cfbae2914e50a922c0e255ec456d690b6e063dd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09139812c6296c48e74531a25a7a7fdda2cda940d2ff4dfb323619cd402f8c7b"
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
