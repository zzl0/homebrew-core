class Ugit < Formula
  desc "Undo git commands. Your damage control git buddy"
  homepage "https://bhupesh.me/undo-your-last-git-mistake-with-ugit/"
  url "https://github.com/Bhupesh-V/ugit/archive/refs/tags/v5.8.tar.gz"
  sha256 "aedc5fd10b82ed8f3c2fc3ffb9d912863a7fec936a9e444a25e8a41123e2e90f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fcbf041c094d1031dbc16f7937fae86b5773a1fc66b786f4b712fd42f3e9ca8"
  end

  depends_on "bash"
  depends_on "fzf"

  def install
    bin.install "ugit"
    bin.install "git-undo"
  end

  test do
    assert_match "ugit version #{version}", shell_output("#{bin}/ugit --version")
    assert_match "Ummm, you are not inside a Git repo", shell_output("#{bin}/ugit")
  end
end
