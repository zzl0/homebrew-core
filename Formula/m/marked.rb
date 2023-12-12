require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-11.1.0.tgz"
  sha256 "ef04a4aeef87fca27584e441148b4f84533cd53138fb8a8a8a136e2465b911d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59303c21db7353c30ad6b42a955ce4d35436404b4aa23efd6f901d9b19b88234"
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
