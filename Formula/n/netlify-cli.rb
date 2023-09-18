require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.3.4.tgz"
  sha256 "2a197cc82e53003ca1cd17051f1cfbaece69cabdb667a507c76b0199c6f22307"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "92b8f685369771e5890e86db5048bd4c0d3235d76452b9359ee21bbe7fce35e3"
    sha256                               arm64_monterey: "72ab8deee39f6ee787eb0787ff10b4d8d1d84d2068fb7e966cc094e2d8973d76"
    sha256                               arm64_big_sur:  "741715658c026cca4532b8774eb9c30d2d997a2ed996baf6425924c1d15ead7d"
    sha256                               ventura:        "92c1f88f44b803ec786fc3d679cc6a0d062bfdc98f40bd4c2136498374ec3f71"
    sha256                               monterey:       "552ebe37a96483e298d93f5a39abb7bdcb9fae07ceb072b7a94f70b5fdaa86c4"
    sha256                               big_sur:        "d19629ce7e4a1f537e11915b26403b2418e03c4fec488a13af3403d2f27bc126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4879cbfb35d526fd97d428aa94bf382d8ce956b2ad77473cb32e1818d6c37815"
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
