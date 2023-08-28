require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.68.0.tgz"
  sha256 "5b8f40d65a22d9c3ec1b692f167e72f68a24c7d227431ca143b2a7d9969cacf1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b37a2533a6928a77054d43aea3212b94e5fc31d5545b1a985d76033acba6ff23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dcaab8d173a09ffe6593604f1db4659febe01831a320bc1b872ff456de9b894"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "546589b0154f3a6d2db8502ca4c97f2734182deba0815ae898eded7646cfc5c1"
    sha256 cellar: :any_skip_relocation, ventura:        "fe93c56c6333b37b6a906cc14281287155a4210717a28809cbafd021820eddd0"
    sha256 cellar: :any_skip_relocation, monterey:       "459d1c45be52afc9e0544f64cb66fe4c80c5de60b91c645a7b9fde9c4fee2401"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb123825960a3c76081cbacbc29e0d6842639cd08b3839ba8f3b23459c691440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255cfabc06f70872afcfad6a807bcee31d4f9a19c1216ad973e886dde3bd7a1e"
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
