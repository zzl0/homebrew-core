require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-12.0.0.tgz"
  sha256 "18c27503f532a8ead55ddda756c07f5e995e567f019c1dc092e06464f3ada47e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "deb317f3265aa18b727cd9e6bf1df341e75966261016904d9c9dcaf60d59fb68"
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
