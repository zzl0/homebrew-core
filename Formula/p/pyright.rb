require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.344.tgz"
  sha256 "a8eba1f77c7b7c4786df276292a14f2cac6293e2ef44ebcf48fb0b0dff48e3e2"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b1c2da4fb0b73c2ec14c7030ae024ce4690cf21070905d3c24adf2f6499bd09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b1c2da4fb0b73c2ec14c7030ae024ce4690cf21070905d3c24adf2f6499bd09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b1c2da4fb0b73c2ec14c7030ae024ce4690cf21070905d3c24adf2f6499bd09"
    sha256 cellar: :any_skip_relocation, sonoma:         "31d1438ba312e3ec3227c65d5200f28705309ca1db45d01d7bdaca3ab07c7a30"
    sha256 cellar: :any_skip_relocation, ventura:        "31d1438ba312e3ec3227c65d5200f28705309ca1db45d01d7bdaca3ab07c7a30"
    sha256 cellar: :any_skip_relocation, monterey:       "31d1438ba312e3ec3227c65d5200f28705309ca1db45d01d7bdaca3ab07c7a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac98176e5a21216d1841816af0d2fe44662dfc429fc2ffbd2fcd5b53b9b63dcb"
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
