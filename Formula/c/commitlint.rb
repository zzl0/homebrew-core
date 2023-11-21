require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-18.4.3.tgz"
  sha256 "b5561489d36cd73dd10bc817df62036e3c35d3ff2ec994efb9fe22fa4f9b31a3"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbe3124c3c8228f672da9464e573f02acff51c694b85f81eeb8fd683faf89ebc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbe3124c3c8228f672da9464e573f02acff51c694b85f81eeb8fd683faf89ebc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbe3124c3c8228f672da9464e573f02acff51c694b85f81eeb8fd683faf89ebc"
    sha256 cellar: :any_skip_relocation, sonoma:         "75ed29e451e03fce9a397c010d5099ce93b153f567a0c151c6aa4394e9b08bce"
    sha256 cellar: :any_skip_relocation, ventura:        "75ed29e451e03fce9a397c010d5099ce93b153f567a0c151c6aa4394e9b08bce"
    sha256 cellar: :any_skip_relocation, monterey:       "75ed29e451e03fce9a397c010d5099ce93b153f567a0c151c6aa4394e9b08bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbe3124c3c8228f672da9464e573f02acff51c694b85f81eeb8fd683faf89ebc"
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
