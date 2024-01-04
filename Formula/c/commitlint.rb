require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-18.4.4.tgz"
  sha256 "eef2f1bb00bb8e342c2bb37fb09e2d7251bd3a01e9e9d7cb33ad4d2e90f5d7ae"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62fff5002b91dd4879ad5338b575d5003af1178902a183d3c748d70a3b1f3732"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62fff5002b91dd4879ad5338b575d5003af1178902a183d3c748d70a3b1f3732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62fff5002b91dd4879ad5338b575d5003af1178902a183d3c748d70a3b1f3732"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd012ae2ad678d76564ca6c131e811f3f85ae68a58b7d60f666e01ae9ea64283"
    sha256 cellar: :any_skip_relocation, ventura:        "fd012ae2ad678d76564ca6c131e811f3f85ae68a58b7d60f666e01ae9ea64283"
    sha256 cellar: :any_skip_relocation, monterey:       "fd012ae2ad678d76564ca6c131e811f3f85ae68a58b7d60f666e01ae9ea64283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62fff5002b91dd4879ad5338b575d5003af1178902a183d3c748d70a3b1f3732"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"commitlint.config.js").write <<~EOS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    EOS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_equal "", pipe_output("#{bin}/commitlint", "foo: message")
  end
end
