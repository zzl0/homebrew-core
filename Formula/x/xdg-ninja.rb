class XdgNinja < Formula
  desc "Check your $HOME for unwanted files and directories"
  homepage "https://github.com/b3nj5m1n/xdg-ninja"
  url "https://github.com/b3nj5m1n/xdg-ninja/archive/refs/tags/v0.2.0.2.tar.gz"
  sha256 "6adfe289821b6b5e3778130e0d1fd1851398e3bce51ddeed6c73e3eddcb806c6"
  license "MIT"
  head "https://github.com/b3nj5m1n/xdg-ninja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "950eb8416c8148030e86ffbeb2b6a4697fa9c0cfa6b163198ccde17a7c323c53"
  end

  depends_on "glow"
  depends_on "jq"

  on_macos do
    depends_on "coreutils"
  end

  def install
    pkgshare.install "programs/"
    pkgshare.install "xdg-ninja.sh" => "xdg-ninja"
    bin.install_symlink pkgshare/"xdg-ninja"
  end

  test do
    system bin/"xdg-ninja"
  end
end
