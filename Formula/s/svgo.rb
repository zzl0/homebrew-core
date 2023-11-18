require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "d46a39601f00448b4cbd5b494869995100f81c17fa0834483b35b256866fe15f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46cd6cc634df3a6c2e0642565cf53440a6cab30a69818b74b848e813fffcb9ce"
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
