require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.348.tgz"
  sha256 "8b511b535259dc4f11471f45ec5559250d40140931a7268371ec2d7b79bc8554"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5832a6fad5396afa52567b9a62324f8263cd7d77ea37a5084f18e46caf0b7a86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5832a6fad5396afa52567b9a62324f8263cd7d77ea37a5084f18e46caf0b7a86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5832a6fad5396afa52567b9a62324f8263cd7d77ea37a5084f18e46caf0b7a86"
    sha256 cellar: :any_skip_relocation, sonoma:         "91b5cb9d7c60fe55800fcf9ad7c7994f52019a2404859c9bd43168689d21108d"
    sha256 cellar: :any_skip_relocation, ventura:        "91b5cb9d7c60fe55800fcf9ad7c7994f52019a2404859c9bd43168689d21108d"
    sha256 cellar: :any_skip_relocation, monterey:       "91b5cb9d7c60fe55800fcf9ad7c7994f52019a2404859c9bd43168689d21108d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41df9245f23c86049ffee5e221f8e91d2ccb372d3372c1cd7914019e1493dc53"
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
