class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.290.tar.gz"
  sha256 "f3be03d9594ded6500b29bc0811c37a2270bbb60a1bbd527a2926e49649966a3"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d435040e5c910e0bfafc9fc51b2819d762ebf792454cd08b9b5fdb8fca2ea3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b013db01af73c9ed64c5c5b0555b6dfdf24c9d0bab3511dc93b85cb968a5b384"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c4bb065aa5d1905f195e3a5aeea0be91800184358b230fc4c9626a509e8a928"
    sha256 cellar: :any_skip_relocation, ventura:        "96597266a454ecc809716ae6b3ddfa7576e27da280ac45c4321e1e555dafeef1"
    sha256 cellar: :any_skip_relocation, monterey:       "34ede5e3a5aecb2b536f519f2900069a2d42428ad2a5000153e591a9a1360472"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5b0ff835c83d3f50674a80f00c30ec35030777c56714a9af9c8cfae74993e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7711b1b1f4a0c884477ed81395ed2d1d123da5ca12da2eaf1b1e2ae775ce744f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
