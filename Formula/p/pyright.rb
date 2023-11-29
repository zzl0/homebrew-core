require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.338.tgz"
  sha256 "52e098c18819fa629647c41d0a5df3ae1db96457842b8236373f6efaf5c2511b"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a41d19325bc979dd0bf471a1cd98c599f4dbaff982ad26932db818ae36736098"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a41d19325bc979dd0bf471a1cd98c599f4dbaff982ad26932db818ae36736098"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a41d19325bc979dd0bf471a1cd98c599f4dbaff982ad26932db818ae36736098"
    sha256 cellar: :any_skip_relocation, sonoma:         "910cb8d1eb0f7ee58d67dac369edafca4010aa18091e928bd2fed936f31ac06e"
    sha256 cellar: :any_skip_relocation, ventura:        "910cb8d1eb0f7ee58d67dac369edafca4010aa18091e928bd2fed936f31ac06e"
    sha256 cellar: :any_skip_relocation, monterey:       "910cb8d1eb0f7ee58d67dac369edafca4010aa18091e928bd2fed936f31ac06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccbbecd36e338d5021fe294cbef4db33424e595a28ae54e1d7568464c0cceb9e"
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
