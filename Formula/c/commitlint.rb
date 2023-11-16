require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-18.4.2.tgz"
  sha256 "64de75f3e23627e5790259d0bba1494be363ed0f5cd55efd3769d29c19805e89"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ea19b91f774ccefe31d079d8e0e5d2ec19d16de21254888d55a81ba32f043ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ea19b91f774ccefe31d079d8e0e5d2ec19d16de21254888d55a81ba32f043ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ea19b91f774ccefe31d079d8e0e5d2ec19d16de21254888d55a81ba32f043ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "a966be0052bcb9a3e21500f71136351dddc04d8f33bde96654890059595887ee"
    sha256 cellar: :any_skip_relocation, ventura:        "a966be0052bcb9a3e21500f71136351dddc04d8f33bde96654890059595887ee"
    sha256 cellar: :any_skip_relocation, monterey:       "a966be0052bcb9a3e21500f71136351dddc04d8f33bde96654890059595887ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea19b91f774ccefe31d079d8e0e5d2ec19d16de21254888d55a81ba32f043ea"
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
