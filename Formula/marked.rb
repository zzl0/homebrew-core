require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-6.0.0.tgz"
  sha256 "ffd373e71a447ec35a3030f73c42f7af59b6b102f6a4a59f4bc3ecbe64c34dab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, ventura:        "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, monterey:       "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2f8a47fa97520dc454a96f4af3c08bdcfdf97af6c88783dcf430f75820e56a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beba770c308f51f3a5422bdde55eb67f73a880e73563af01f2a8eb0dbfbc25e7"
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
