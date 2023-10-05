require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.1.0.tgz"
  sha256 "fa36d754e1c081d9ed4a5d811622cbfce0a24a5a5b0af1da87342a274750062b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1df344086cb536cc0f87c32355431e88c6c2323ced6e2fa2b388ae4012b83eeb"
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
