require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.0.0.tgz"
  sha256 "6353ad38a562837938aa3e690ebce5e5ca1d32d0341574c4e2c07618edd0fc46"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "28a801ea4fca77dd7f167be0a53e617a6472b72b8921170a020ee2678b08b45b"
    sha256                               arm64_monterey: "a489a10ace1a7ba43dc3c94a1a3e0939ead084ea4689dc82bfd3d08d8a7791d7"
    sha256                               arm64_big_sur:  "b4b6d45260c5c1aa903ec34ba806739c4fb2a1aeb531bf3dedef345c39c5fa40"
    sha256                               ventura:        "04002d0da4f9e11145eebd2b7c116dc09823c0e8756d39412b4ad113ab9a6e03"
    sha256                               monterey:       "d3eac3a3509c1226dea98fb335c58da224c6b078444fe3ee426d0410f9b3a070"
    sha256                               big_sur:        "1a0904982f3fb189d3a350a95a17da5b8aa8f9bbea1a9029fac68a61efb9634c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34cf9b62d7c62c43a7aa28678e9ab44080d44de81c9ddea63b10f60159312923"
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
