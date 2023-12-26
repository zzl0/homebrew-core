require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.343.tgz"
  sha256 "864ba5cda8158fc9de24410761b1e33b982351426f9b9a2619b2474a72b09064"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efee3a5d2929704a807a3cf90afc4aa7f48bac3d832f330eaf9a3393d3de953d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efee3a5d2929704a807a3cf90afc4aa7f48bac3d832f330eaf9a3393d3de953d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efee3a5d2929704a807a3cf90afc4aa7f48bac3d832f330eaf9a3393d3de953d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a4b1b75162e3c15104f4046b24005547d4e264c7adc8c7f71f328939a64ae3e"
    sha256 cellar: :any_skip_relocation, ventura:        "7a4b1b75162e3c15104f4046b24005547d4e264c7adc8c7f71f328939a64ae3e"
    sha256 cellar: :any_skip_relocation, monterey:       "7a4b1b75162e3c15104f4046b24005547d4e264c7adc8c7f71f328939a64ae3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e35d1490decca5ade7d49acffe88c69c01afc001bc0e1ef8ab051299c52fdd3b"
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
