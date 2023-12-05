require "language/node"

class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://github.com/joernio/astgen/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "609193fa5e489cfeaa7d1ca3a66e9db932f4c3b886e2f49cdc4f6c2db9aca736"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f0ecbc320ac521a77533965b29133dc4a5e05ae8d17795295075455eebbd576"
  end

  depends_on "node"

  def install
    # Disable custom postinstall script
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--ignore-scripts"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"main.js").write <<~EOS
      console.log("Hello, world!");
    EOS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match '"fullName": "main.js"', (testpath/"out/main.js.json").read
    assert_match '"0": "Console"', (testpath/"out/main.js.typemap").read
  end
end
