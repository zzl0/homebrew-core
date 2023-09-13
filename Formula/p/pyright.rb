require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.327.tgz"
  sha256 "f8168fa605a665c8fc24474450ed90a91b710011175f2c8c744e21aa966e2fe8"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61c5419a8ca31781655c298490e9963d4e9e5d1bc55bc7b75a4b12ce57d4f23e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61c5419a8ca31781655c298490e9963d4e9e5d1bc55bc7b75a4b12ce57d4f23e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61c5419a8ca31781655c298490e9963d4e9e5d1bc55bc7b75a4b12ce57d4f23e"
    sha256 cellar: :any_skip_relocation, ventura:        "d1c48ea1b8042bac2691c1269f529ae243cf223ea45d88ca04d6a40875bc13b8"
    sha256 cellar: :any_skip_relocation, monterey:       "d1c48ea1b8042bac2691c1269f529ae243cf223ea45d88ca04d6a40875bc13b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1c48ea1b8042bac2691c1269f529ae243cf223ea45d88ca04d6a40875bc13b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f72d88c2effb0af0920385e99f91b0746bad12494e4568904d40f98464915cfb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end
