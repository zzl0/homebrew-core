require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-10.0.0.tgz"
  sha256 "7a59fa1e236734cae675636fe2e9f99dc826db0b020145618d1f312af919e2a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e8accd64ef9fbacd2f8401715741a202766cbc7130a6bd2a839d03df781106b"
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
