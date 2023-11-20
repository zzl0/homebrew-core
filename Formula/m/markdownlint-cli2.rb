require "language/node"

class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting Markdown/CommonMark files"
  homepage "https://github.com/DavidAnson/markdownlint-cli2"
  url "https://registry.npmjs.org/markdownlint-cli2/-/markdownlint-cli2-0.11.0.tgz"
  sha256 "1e0f3dc33e6670643239542a0767b5a81bfd2d66308f4739a296ff06e6c3b295"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a571c4493804f694dd00303e420c088267a59e494c110c517c6d6396a172e5f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test-bad.md").write <<~EOS
      # Header 1
      body
    EOS
    (testpath/"test-good.md").write <<~EOS
      # Header 1

      body
    EOS
    assert_match "Summary: 1 error(s)",
      shell_output("#{bin}/markdownlint-cli2 :#{testpath}/test-bad.md 2>&1", 1)
    assert_match "Summary: 0 error(s)",
      shell_output("#{bin}/markdownlint-cli2 :#{testpath}/test-good.md")
  end
end
