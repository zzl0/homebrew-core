require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.43.0.tgz"
  sha256 "cc37e772a9657c6875c7bc69c1dba75162177b3d516623a25fa29e736fb7d279"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e414c020deb9888ac23127e9d08bf341bbca7172217b144b2a6daea2562ba73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fec0895df3c2f78d16f85fcef1f8c6de313bc41f111d64ef4fa882f23f8eea9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "524ac44b9d89e43d0267a02fc3aa40b6b9a04b1dbb3ef96f2b913d59549efd12"
    sha256 cellar: :any_skip_relocation, ventura:        "0f7799871676e5d3ae0ba95e1ac37302be9f7a12dc1dc929eed612afbe0e8d6d"
    sha256 cellar: :any_skip_relocation, monterey:       "40d07f8667bd1290b90b952fe394aeeee8b0e81f2c1f54d9c7500e73465dbabf"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a71f41d2270816d27b64f23fae44d5ebf2aaedb14f096b83f8674f05033c2e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ccaa5eca83529e08c7d2a7344c638da9add30fdc46176833e873b5b5c54259f"
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
