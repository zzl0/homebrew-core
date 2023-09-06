require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.3.1.tgz"
  sha256 "92d68300fe596541bdd3f15e3ea155de0ce7af857d4be7648d4e1991cdd025bd"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "7c90cbe1e04312f2a9f69dd00c675907a6bfaf58b65ed53b888646703e16c40b"
    sha256                               arm64_monterey: "201897bd543a67a38179a811461e7f15aaae835bb9ad78de387a846fda932807"
    sha256                               arm64_big_sur:  "36cfc2f1cf192fe77fab6f42d5988042c88c0f398f6451c735898d2893e5369e"
    sha256                               ventura:        "e8f540baef1085ce715478062c5f76317c9ae1d1d33c579ed9d318e57e7562f4"
    sha256                               monterey:       "641b4a3d01efd4ba769a5fd968816bcd206e3f0f3c3ab328494a980d2d2eb929"
    sha256                               big_sur:        "9a898c9c4076a78531c0c209cebe1ce42bb38b84f714c36abd5f997b9f180483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36e746f079ba598a496bd994b3da9fc294b24714e5303b3ea07d7e9ac7e38ab8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
