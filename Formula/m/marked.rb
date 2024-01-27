require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-11.2.0.tgz"
  sha256 "d6795826b31dd2d9dc39634b1a9f6531ac6cf7aba3f9d200671963e6cc74867d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ff0dd9d8bf4cc178929d601b5dcab3814cb0021b6f700ee2a9d86ae9ba0e2807"
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
