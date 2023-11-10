require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-1.2.0.tgz"
  sha256 "622bb5cfa89221eab05c5bbcf23c10fc7110c9acafa13e454aa059560aa1e03e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bb934e11c1c2ba84237c261384ce96477928c4daa57d0fb72f4dc1ced11fc59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bb934e11c1c2ba84237c261384ce96477928c4daa57d0fb72f4dc1ced11fc59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bb934e11c1c2ba84237c261384ce96477928c4daa57d0fb72f4dc1ced11fc59"
    sha256 cellar: :any_skip_relocation, sonoma:         "6328f95db139186b3f9d001b560c336154b86a301d96e7c780573fb3d898d21f"
    sha256 cellar: :any_skip_relocation, ventura:        "6328f95db139186b3f9d001b560c336154b86a301d96e7c780573fb3d898d21f"
    sha256 cellar: :any_skip_relocation, monterey:       "6328f95db139186b3f9d001b560c336154b86a301d96e7c780573fb3d898d21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bb934e11c1c2ba84237c261384ce96477928c4daa57d0fb72f4dc1ced11fc59"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna endpoint list 2>&1")
    assert_match "Available endpoints:\n", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https://github.com/jdxcode/password-prompt/issues/12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = shell_output("#{bin}/fauna endpoint add https://db.fauna.com:443 " \
                          "--non-interactive --url http://localhost:8443 " \
                          "--secret your_fauna_secret --set-default")
    assert_match "Saved endpoint https://db.fauna.com:443", output

    expected = <<~EOS
      Available endpoints:
      * https://db.fauna.com:443
    EOS
    assert_equal expected, shell_output("#{bin}/fauna endpoint list")
  end
end
