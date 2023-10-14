require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.1.0.tgz"
  sha256 "0ab1e0e19e7162c8876dfbc9df208e566c43232478b92caec84d9d73aab344e4"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a71eab9f52b14d17703278a0a468be514b1371bfa31f6c44a986b1451284170e"
    sha256 cellar: :any,                 arm64_ventura:  "a71eab9f52b14d17703278a0a468be514b1371bfa31f6c44a986b1451284170e"
    sha256 cellar: :any,                 arm64_monterey: "a71eab9f52b14d17703278a0a468be514b1371bfa31f6c44a986b1451284170e"
    sha256 cellar: :any,                 sonoma:         "ff85f531de62061c75a2c8fae306ce9996edce5521a959f72658894bfb918d55"
    sha256 cellar: :any,                 ventura:        "ff85f531de62061c75a2c8fae306ce9996edce5521a959f72658894bfb918d55"
    sha256 cellar: :any,                 monterey:       "ff85f531de62061c75a2c8fae306ce9996edce5521a959f72658894bfb918d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "887158a85a88629d1215243c774a4f1e3512f2f1c76a0f079e67ae1f2d96bb23"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/rollup/node_modules"
    (node_modules/"@rollup/rollup-linux-x64-musl/rollup.linux-x64-musl.node").unlink if OS.linux?

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
