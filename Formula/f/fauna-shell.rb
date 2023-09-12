require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-1.1.0.tgz"
  sha256 "5a098e3bf6233c66bee1c036089261ee06f17d0a959766ab678b432eeb542797"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af3e048d4595c4a46cca269fed28ece528fc0f2252fa47bb6c949b227bb0dfa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af3e048d4595c4a46cca269fed28ece528fc0f2252fa47bb6c949b227bb0dfa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af3e048d4595c4a46cca269fed28ece528fc0f2252fa47bb6c949b227bb0dfa3"
    sha256 cellar: :any_skip_relocation, ventura:        "b34935256b92bce30a8b46785660c0575a9b41c3e8c35a12a4647b096cf22df9"
    sha256 cellar: :any_skip_relocation, monterey:       "b34935256b92bce30a8b46785660c0575a9b41c3e8c35a12a4647b096cf22df9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b34935256b92bce30a8b46785660c0575a9b41c3e8c35a12a4647b096cf22df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3e048d4595c4a46cca269fed28ece528fc0f2252fa47bb6c949b227bb0dfa3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https://github.com/jdxcode/password-prompt/issues/12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_match "fauna_endpoint *\n", output
  end
end
