require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.28.1.tgz"
  sha256 "e5e9b7504594172da43015a1cc9b40a5c18230a93ca9180f3a433ae28785fbc1"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29dfdc753f7968f91ae1d8511b24653147b71cf32583ae95f7723223001369e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29dfdc753f7968f91ae1d8511b24653147b71cf32583ae95f7723223001369e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29dfdc753f7968f91ae1d8511b24653147b71cf32583ae95f7723223001369e4"
    sha256 cellar: :any_skip_relocation, ventura:        "74ec4d342a6b2bf0cc4bf712c8b98a309f5082b208a8810ea89796c811881dc3"
    sha256 cellar: :any_skip_relocation, monterey:       "74ec4d342a6b2bf0cc4bf712c8b98a309f5082b208a8810ea89796c811881dc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "74ec4d342a6b2bf0cc4bf712c8b98a309f5082b208a8810ea89796c811881dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9598113f86a7e37813c2906a870bfab13cfb3bb4885660dbefc0dbb0e2fb54df"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
