require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-11.0.1.tgz"
  sha256 "28530059e48015f6f5d5046e6df0ee57a34c25b944fc20323153d51ee289a573"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf55e3784cd9ed8d13cd31e9ae5e0f84869c2205327e5e6caa7ab642f7392fc7"
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
