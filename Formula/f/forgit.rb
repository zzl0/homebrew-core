class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https://github.com/wfxr/forgit"
  url "https://github.com/wfxr/forgit/releases/download/24.02.0/forgit-24.02.0.tar.gz"
  sha256 "020e9cf1d015fee7bd19d64ca2076f22570816eb48e3ec9c860ee1bad3dee388"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "43bce62f9fa1359c94c1ef9c0d6604aa6d1c5e6df62bd06d131dd21288eafb98"
  end

  depends_on "fzf"

  def install
    bin.install "bin/git-forgit"
    bash_completion.install "completions/git-forgit.bash" => "git-forgit"
    zsh_completion.install "completions/git-forgit.zsh" => "_git-forgit"
    inreplace "forgit.plugin.zsh", 'FORGIT="$INSTALL_DIR', "FORGIT=\"#{opt_prefix}"
    inreplace "conf.d/forgit.plugin.fish",
              'set -x FORGIT "$FORGIT_INSTALL_DIR/bin/git-forgit"',
              "set -x FORGIT \"#{opt_prefix}/bin/git-forgit\""
    pkgshare.install "conf.d/forgit.plugin.fish"
    pkgshare.install "forgit.plugin.zsh"
    pkgshare.install_symlink "forgit.plugin.zsh" => "forgit.plugin.sh"
  end

  def caveats
    <<~EOS
      A shell plugin has been installed to:
        #{opt_pkgshare}/forgit.plugin.zsh
        #{opt_pkgshare}/forgit.plugin.sh
        #{opt_pkgshare}/forgit.plugin.fish
    EOS
  end

  test do
    system "git", "init"
    (testpath/"foo").write "bar"
    system "git", "forgit", "add", "foo"
  end
end
