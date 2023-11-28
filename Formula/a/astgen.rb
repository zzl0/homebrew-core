require "language/node"

class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://github.com/joernio/astgen/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "dd88eeee59e118dcf818d2cbe56dcb6a85f780d74601a5db96f4e55869ec22f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c41ac07344ce02cd8ed67bb587191e299cf26bfaa00bb1f1e2468f043a80f07"
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
