require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.0.3.tgz"
  sha256 "455b78959f1ba0a77ad8501ed0f24ef31f235fa625ce670cb53db925973c444c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb8acb2d8fcbc60fb173c6c1fda450fbb3a04676fa807a7e790d8a2b30be9720"
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
