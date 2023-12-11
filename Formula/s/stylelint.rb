require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.0.2.tgz"
  sha256 "7e37b3ca89dfef5618a29402e462cfe5582caebc4bfe98e74e2bb423620c509c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eecb10de24a9b108142d162e77168c11c1a20cab82a288b1d454b87d3b24304a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eecb10de24a9b108142d162e77168c11c1a20cab82a288b1d454b87d3b24304a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eecb10de24a9b108142d162e77168c11c1a20cab82a288b1d454b87d3b24304a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1defab64466887b3f862daf7058cd2aca46d727a8b6516ce59cc42ed400a8825"
    sha256 cellar: :any_skip_relocation, ventura:        "1defab64466887b3f862daf7058cd2aca46d727a8b6516ce59cc42ed400a8825"
    sha256 cellar: :any_skip_relocation, monterey:       "1defab64466887b3f862daf7058cd2aca46d727a8b6516ce59cc42ed400a8825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eecb10de24a9b108142d162e77168c11c1a20cab82a288b1d454b87d3b24304a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
