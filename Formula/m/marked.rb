require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.0.1.tgz"
  sha256 "975df3858273aae162dbc31c24e26d3dac58922a5a95b441dc3fbc4ce3cb5991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19013ccc5f2cca48cd1289824c61fc7a5350090d1b61ef493e64b482e7e4259d"
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
