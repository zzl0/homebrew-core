require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-7.0.0.tgz"
  sha256 "fe7e33beeabea16b26e6174fcdeda2183cc22c281649b659db26e250c32392bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, ventura:        "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, monterey:       "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbb032c5d6b588e449a3d83709cde8c042e795f4cac6e37dde655af0422d5859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55da1179378a493b7cc1b5c6fb2cfd8434a0be74404a60650d57cb541e4c887b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
