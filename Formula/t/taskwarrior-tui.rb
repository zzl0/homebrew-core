class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.25.3.tar.gz"
  sha256 "6bd6e838ee867a8ca6f3dd51823f8f17447471405d82c612ce21e938a41c4255"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe752cc0b823b16572dca11fa5d8e153b964faf02f4beb8360762717546e08af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba66301851aa3e0c314d77611cc013e4add8045a1c5d7ae7ce0f8437e74be888"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa90e65b4317226a431703102587905a85cb49391e979d541cb839f0ec5c43d4"
    sha256 cellar: :any_skip_relocation, ventura:        "b8d8ab0e12d990f8820cbadda47bd975a208924731818bfc6a9a6fb996b7982c"
    sha256 cellar: :any_skip_relocation, monterey:       "243ba9a2ebf270ca0325844859a03b3bbbf794906b6c1f4dc6b85e3a0e04f4cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5ac29a968ca11333590b1623f41d8034e7032fe01c80451235389713f904cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a56378236be078ad3c1bd98c7abe8d39f06be08261818fa4c8e3de08214e0da"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
