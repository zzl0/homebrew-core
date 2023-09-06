require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-8.0.1.tgz"
  sha256 "28183493bd3ba5fad070689b1d0f4116e3266768121aee81aaa08ac8c8d1d7dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be463b588bd6182d8226a6172ea1310c0435374b6e26432956184856d85a9826"
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
