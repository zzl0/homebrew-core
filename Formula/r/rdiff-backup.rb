class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/e9/9b/487229306904a54c33f485161105bb3f0a6c87951c90a54efdc0fc04a1c9/rdiff-backup-2.2.6.tar.gz"
  sha256 "d0778357266bc6513bb7f75a4570b29b24b2760348bbf607babfc3a6f09458cf"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "0c0078f8d979ea77e3c762d180527f21cf802fd6b374e7600ec2f3ce0642ddff"
    sha256 cellar: :any,                 arm64_ventura:  "c8cbb2ba92cd4444c7984ba20f9ea396946d56ca92b76ac7472164199d94ed6a"
    sha256 cellar: :any,                 arm64_monterey: "6189ac0853ecd011f4cabd5200a4a66cbf11e7ecf651dd1ca6b184b25cb249ae"
    sha256 cellar: :any,                 sonoma:         "15d9fafa877e2ce4ef11928cc7a2b102fcf2d5386dd83f4fef273f0a6e4510c2"
    sha256 cellar: :any,                 ventura:        "a4795c66b33328a5e213e36171c589f2e182bf1023f2d446d77a63d59b894854"
    sha256 cellar: :any,                 monterey:       "c038930bc65163511da5add62466b0273b6646ae66e3a2dacefd44688bd0c1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f2f55b588b003b97ef53214961864fd4e01fe2892fc494f1e34b3e7b8de7c2"
  end

  depends_on "python-setuptools" => :build
  depends_on "librsync"
  depends_on "python@3.12"
  depends_on "pyyaml"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end
