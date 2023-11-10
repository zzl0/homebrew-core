class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.8.0.tar.gz"
  sha256 "2cd7df83c6f24625b2ee671ed0f1e2caf9adc297231d851ce6da4cc6909247c6"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cc68324b29d8fa9c6e2e8674fe85aac1bf9f7a5752fd23005684900001cc461"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cc68324b29d8fa9c6e2e8674fe85aac1bf9f7a5752fd23005684900001cc461"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cc68324b29d8fa9c6e2e8674fe85aac1bf9f7a5752fd23005684900001cc461"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e1d04887472c3e13e17ee2cd86e5c769645972725320a23f8ba339ddaf86dfe"
    sha256 cellar: :any_skip_relocation, ventura:        "9e1d04887472c3e13e17ee2cd86e5c769645972725320a23f8ba339ddaf86dfe"
    sha256 cellar: :any_skip_relocation, monterey:       "9e1d04887472c3e13e17ee2cd86e5c769645972725320a23f8ba339ddaf86dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc68324b29d8fa9c6e2e8674fe85aac1bf9f7a5752fd23005684900001cc461"
  end

  depends_on "bat"
  depends_on "nmap"
  depends_on "pandoc"
  depends_on "ripgrep"
  depends_on "tig"
  depends_on "w3m"

  uses_from_macos "bash"

  def install
    bin.install "nb", "bin/bookmark"

    bash_completion.install "etc/nb-completion.bash" => "nb.bash"
    zsh_completion.install "etc/nb-completion.zsh" => "_nb"
    fish_completion.install "etc/nb-completion.fish" => "nb.fish"
  end

  test do
    # EDITOR must be set to a non-empty value for ubuntu-latest to pass tests!
    ENV["EDITOR"] = "placeholder"

    assert_match version.to_s, shell_output("#{bin}/nb version")

    system "yes | #{bin}/nb notebooks init"
    system bin/"nb", "add", "test", "note"
    assert_match "test note", shell_output("#{bin}/nb ls")
    assert_match "test note", shell_output("#{bin}/nb show 1")
    assert_match "1", shell_output("#{bin}/nb search test")
  end
end
