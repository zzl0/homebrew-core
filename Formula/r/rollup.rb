require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-4.1.6.tgz"
  sha256 "f20d3fa1439fa2becb5ba6211c357ed1af10878ca7d7b0a9bc2dfe8a1cf50d6e"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f4c2a9a990220fa9426d64f7eeaf2dec4a7d945176e31ce816f39ebc2a43269f"
    sha256 cellar: :any,                 arm64_ventura:  "f4c2a9a990220fa9426d64f7eeaf2dec4a7d945176e31ce816f39ebc2a43269f"
    sha256 cellar: :any,                 arm64_monterey: "f4c2a9a990220fa9426d64f7eeaf2dec4a7d945176e31ce816f39ebc2a43269f"
    sha256 cellar: :any,                 sonoma:         "bfb6af95b6b6f0b5e49e59e69c6f31fc0e5bd9e416bb4dca824b729b6cc3e48b"
    sha256 cellar: :any,                 ventura:        "bfb6af95b6b6f0b5e49e59e69c6f31fc0e5bd9e416bb4dca824b729b6cc3e48b"
    sha256 cellar: :any,                 monterey:       "bfb6af95b6b6f0b5e49e59e69c6f31fc0e5bd9e416bb4dca824b729b6cc3e48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a079da161d7f663f9d4c444c1552e179c95bf66457414f6025e04aa2b21606a"
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
