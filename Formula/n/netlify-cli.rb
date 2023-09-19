require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.4.0.tgz"
  sha256 "b8149b87c0767a2727803e20fc6dbb68bb8de6e73d1a085671dc4862061d955e"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "be661246d12932d7704d339e5880896a87be6df2e66cd1ed48c434ad816e74a1"
    sha256                               arm64_monterey: "f66c816d7f049e358ac3e56a65496bebe5a85faa69d5811cbd70734e724df968"
    sha256                               arm64_big_sur:  "cbc4862a4b10424d1e122498c2bbcf1b62e6add061640fe537b612614fb6f34c"
    sha256                               ventura:        "e3d68e2b02914b35dff634a148280dba5c1e45eec5b4b7c55e5a1abb0e10ead5"
    sha256                               monterey:       "c77b4fabaa78ee5d71519dda910dab437c314764c9c309276b5e30b7cee035b2"
    sha256                               big_sur:        "b2d9de056a6221044ef7f01a38f47c4ea7759c7b70c61d21e8613b6f169761f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8de30ef7f1b055e3ad7e508526d8041b7b6be847ea501f456a52252043fc6ab"
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
