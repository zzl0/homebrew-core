class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.40.1.tar.gz"
  sha256 "86d4f850c3252573bc098bdc76adb2b825ea847a51c8cb3a55caf36c93418034"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9efd61836672f52fe1d79a492383ef21598fdb2218a7af1998d9230a6ec13644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9efd61836672f52fe1d79a492383ef21598fdb2218a7af1998d9230a6ec13644"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9efd61836672f52fe1d79a492383ef21598fdb2218a7af1998d9230a6ec13644"
    sha256 cellar: :any_skip_relocation, ventura:        "80c0c0404c3fc25142e5701e25ce9e4c26f9f562669e2792fca0537ae0c5a5f0"
    sha256 cellar: :any_skip_relocation, monterey:       "80c0c0404c3fc25142e5701e25ce9e4c26f9f562669e2792fca0537ae0c5a5f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "80c0c0404c3fc25142e5701e25ce9e4c26f9f562669e2792fca0537ae0c5a5f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d984165ce1b604d555d22aa348572f86d12d3d5ec442eaa3f2520f47a01dd93"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' to do certain tasks
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_DAEMON_KIND"] = "2" # cherry pick commit
    ENV["LAZYGIT_DAEMON_INSTRUCTION"] = "{\"Todo\":\"pick 401a0c3\"}"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "pick 401a0c3", (testpath/"git-rebase-todo").read
  end
end
