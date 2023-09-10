require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.0.0.tgz"
  sha256 "5a41d190947b7389c32d5449d1c39c2195d7286b4ca983bd5b46a71b0a7109b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6a0a47d7cd146f5fd0b75f68e338d28d848135ee382f2998d8de4916ce219bb"
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
