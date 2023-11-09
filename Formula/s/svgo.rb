require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "37e9ae561c80563eb08954c36a97793ed5022374508dd2bc38ed3e920be0aa80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "684741c0ba97f3a8b5976b43eb874a8189742b48580d970ba80c3a10ee0dc863"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end
