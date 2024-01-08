require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.345.tgz"
  sha256 "dae68a8441532b4256ec84574dae9efddd96c8b37fa6394bb7a73126e1bec998"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6079d3edca13a28b5b63d511337e656d149bb52ad12235d28c9ae1bc4e817a13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6079d3edca13a28b5b63d511337e656d149bb52ad12235d28c9ae1bc4e817a13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6079d3edca13a28b5b63d511337e656d149bb52ad12235d28c9ae1bc4e817a13"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f17f5d246b87621148fb8f8ae2d07eddcd4a25bf6589d784b3827d2852ef9be"
    sha256 cellar: :any_skip_relocation, ventura:        "1f17f5d246b87621148fb8f8ae2d07eddcd4a25bf6589d784b3827d2852ef9be"
    sha256 cellar: :any_skip_relocation, monterey:       "1f17f5d246b87621148fb8f8ae2d07eddcd4a25bf6589d784b3827d2852ef9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c3b5ad0ca2a750d72e3b1d20752aabe99fa1429c7bf3628eacb18fc21d44b4a"
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
