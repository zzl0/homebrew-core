require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.1.2.tgz"
  sha256 "50a45f9a66460244f92b7cd3544664cc763da6a7f2a5ef2c81e620aaf463b445"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5123607d24eaa0e6f4aeed278cb55f0c19d9a7e27dfbd9fb12a320c81e2a3d7b"
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
