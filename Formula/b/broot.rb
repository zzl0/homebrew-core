class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "d8ead543cf84c6b075eb7f938b29bf60473523971f80ca3a8b6bd6e0b1d0f3a7"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e130d69a39babf7bcf6b07bf720dc238836e24c8fdff6fe2012786da51785250"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76de07140145a12ea32b6c5ff3a7958803053eb088d78bae2d74a125d09f4e1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5daf531a90e9d0ffc3abdc043d787bca6540cdfeab9217f08ac0e228050669f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "932cf853061b0a2101b4a92bbdcfbdae4e00533c9b68ed2c1a293ccd60650a2c"
    sha256 cellar: :any_skip_relocation, ventura:        "4063623863286fc03a9b7984d4a4a1142f5924d38a7632005e0e6922f6c89d81"
    sha256 cellar: :any_skip_relocation, monterey:       "c1dc16bf196dcf3ffbf79f70e0fe261d87a9906bca7cd2e502cb22ed0c1a17e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67ac94a6ca26077772995124680b6e2eecc9a1139528674c8a7629e6cd0bf990"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version.to_s
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output

    assert_match version.to_s, shell_output("#{bin}/broot --version")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt",
                err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      assert_match "New Configuration files written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
