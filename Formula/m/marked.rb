require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-7.0.5.tgz"
  sha256 "fadbf37b8fe7bb602f19f59a20209b69bfc7a61c81e91656ae86e909ccccf7ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bffe57614f1ff230554dd382c2ff4bb0f761752e49c9b79d1f34fa01c4af19e3"
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
