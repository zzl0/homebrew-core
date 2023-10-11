require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.1.1.tgz"
  sha256 "f4862a678e332f6214aed64692cf7db11ed51ea49a68c02d1c58e1d2ae8cedde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e011c71ab833a11e5af3b2949fa73b54f49c02456ef4343c861f28c1b7ba0a3"
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
