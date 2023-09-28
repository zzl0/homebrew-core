require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.7.2.tgz"
  sha256 "d268c88c1b2ecc4efe8738b18f61128ae8003fe7def2a4197751aa9a0631633f"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "308b085be47328ba8687c1b10f60f9aa4c88d71b5f8e3a54fe4c24765cbaf7f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "308b085be47328ba8687c1b10f60f9aa4c88d71b5f8e3a54fe4c24765cbaf7f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "308b085be47328ba8687c1b10f60f9aa4c88d71b5f8e3a54fe4c24765cbaf7f9"
    sha256 cellar: :any_skip_relocation, ventura:        "d055b6dbbd3d212f3cf6a3ab594e683274f4bd9c6e7bd0c351f6088f5962adaf"
    sha256 cellar: :any_skip_relocation, monterey:       "d055b6dbbd3d212f3cf6a3ab594e683274f4bd9c6e7bd0c351f6088f5962adaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d055b6dbbd3d212f3cf6a3ab594e683274f4bd9c6e7bd0c351f6088f5962adaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "308b085be47328ba8687c1b10f60f9aa4c88d71b5f8e3a54fe4c24765cbaf7f9"
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
