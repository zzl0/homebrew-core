require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.42.0.tgz"
  sha256 "07c4ac0a4588443b47d33b43162774737d75b74092ecc6fa9638dfc87e068be6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "395d807bffef3833cd169c480b01df0b4d9b6bec9d8ef29aa461a895377ae624"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "022d8aa8432642170e9a4bd153edc772460f6844b8e85cf65b7e38295d44f914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7facbe963ba8b9e94f825887f536f4d3789b0f24741e854100d07de60ac9aca3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cbd4cf45392a828b8f3f6d3d25d69395e61ef1c99634aa72198a7710406f241"
    sha256 cellar: :any_skip_relocation, ventura:        "97bbde2c101f4397614c2026a390e4d0ad6b912f88445532d95f4a8a8dc2efdd"
    sha256 cellar: :any_skip_relocation, monterey:       "de2b42e25d5043c928ee8e8a74128829372dee5af4e3cbd74fededef85294f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0307964cfdbcc1607b0df6c4fcfc251437f8e7b2d63f1ff59184e6aedf2bc41b"
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
