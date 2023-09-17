require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.0.2.tgz"
  sha256 "c7a6b3f036199dcfe69480027b8788a23e46d5de3b91ae2216c49f09c0fb6da2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef9904346dcbf87628fa6d1fa216a23f06aa5f2ec7aca53e88c9a368c75d34c7"
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
