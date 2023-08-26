require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-52.0.0.tgz"
  sha256 "483c4fc8e941d5f870c610150f61835ff92ee313688bd3262cf3dca6fb910876"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c5adbeb350644650e7b3347bdbbc30f8a568b08c67b507ebfe5575be25774d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c5adbeb350644650e7b3347bdbbc30f8a568b08c67b507ebfe5575be25774d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c5adbeb350644650e7b3347bdbbc30f8a568b08c67b507ebfe5575be25774d6"
    sha256 cellar: :any_skip_relocation, ventura:        "06775f9777b106bd0dd205afa024e43987c64666afa396d49a2fcadbc0121878"
    sha256 cellar: :any_skip_relocation, monterey:       "06775f9777b106bd0dd205afa024e43987c64666afa396d49a2fcadbc0121878"
    sha256 cellar: :any_skip_relocation, big_sur:        "06775f9777b106bd0dd205afa024e43987c64666afa396d49a2fcadbc0121878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5adbeb350644650e7b3347bdbbc30f8a568b08c67b507ebfe5575be25774d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
