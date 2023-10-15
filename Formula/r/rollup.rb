require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.1.3.tgz"
  sha256 "0f70bf6e8b9ce458dc9889d7ac8cad938cbb685d43b90b2f7dd1fc868881a759"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e2f7056ce2c95d14028753f3ec85936777d9bf61f40f9d1fe1d867d6bcf68f7f"
    sha256 cellar: :any,                 arm64_ventura:  "e2f7056ce2c95d14028753f3ec85936777d9bf61f40f9d1fe1d867d6bcf68f7f"
    sha256 cellar: :any,                 arm64_monterey: "e2f7056ce2c95d14028753f3ec85936777d9bf61f40f9d1fe1d867d6bcf68f7f"
    sha256 cellar: :any,                 sonoma:         "8e17ed3b7ad7a760790c8820c1501c2c18f1465cac21783eabe91535c72bb52c"
    sha256 cellar: :any,                 ventura:        "8e17ed3b7ad7a760790c8820c1501c2c18f1465cac21783eabe91535c72bb52c"
    sha256 cellar: :any,                 monterey:       "8e17ed3b7ad7a760790c8820c1501c2c18f1465cac21783eabe91535c72bb52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "190fda467c50a8a02394982d82b31b01a620693fcb9b3a633bae2bcda73d287c"
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
