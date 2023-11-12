require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-18.4.1.tgz"
  sha256 "19dcda21df7a28ec9b157ead91705de13433e88d615747ccce92d7edf5bf80f1"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "992f1584254394d6143a079e90ba756422f84cd750eb5001ed2822afa259aeba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "992f1584254394d6143a079e90ba756422f84cd750eb5001ed2822afa259aeba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "992f1584254394d6143a079e90ba756422f84cd750eb5001ed2822afa259aeba"
    sha256 cellar: :any_skip_relocation, sonoma:         "12f4f438305aaffd620da6c53df1b5fdada1217fd5a5c529ef890d470da7958a"
    sha256 cellar: :any_skip_relocation, ventura:        "12f4f438305aaffd620da6c53df1b5fdada1217fd5a5c529ef890d470da7958a"
    sha256 cellar: :any_skip_relocation, monterey:       "12f4f438305aaffd620da6c53df1b5fdada1217fd5a5c529ef890d470da7958a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "992f1584254394d6143a079e90ba756422f84cd750eb5001ed2822afa259aeba"
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
