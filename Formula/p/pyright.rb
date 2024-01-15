require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.347.tgz"
  sha256 "21ed53b028c864b48a76605a270939a3b246d0faadc2beaacfd8ae25977c39dc"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "753f36b5b85f966dda25b3b09ec2ebd51350568ce4445753561be95de02d424c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "753f36b5b85f966dda25b3b09ec2ebd51350568ce4445753561be95de02d424c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "753f36b5b85f966dda25b3b09ec2ebd51350568ce4445753561be95de02d424c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7400a8aa9b7ee8ae30e86746e6a423a3619ce94fa1e0defa7b40b21af216398e"
    sha256 cellar: :any_skip_relocation, ventura:        "7400a8aa9b7ee8ae30e86746e6a423a3619ce94fa1e0defa7b40b21af216398e"
    sha256 cellar: :any_skip_relocation, monterey:       "7400a8aa9b7ee8ae30e86746e6a423a3619ce94fa1e0defa7b40b21af216398e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54ada8c320a94b8a0500cae92d8bf571e8a957caf7690f9169c599c96124fd5"
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
