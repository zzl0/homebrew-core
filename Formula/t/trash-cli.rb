class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/22/d1/0901ab1d04b296ea5a93d970299b1735b6e2bff49ea3c41bf910919be821/trash-cli-0.23.9.23.tar.gz"
  sha256 "d367f0a70b3b1c20d97bcb459c552eeefc42e7e8d00f2af334236708ec047584"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2ee58b9d049653b7d6386c694d0c58ac660a78ac6cc5ca63e351fc3dfd39bca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "411348e2a47d7fe324c9cb4b986a03c8754fad1a662502e792d76bda348a759b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c54b56312c420747ff57a11d46d86aa13cfa6f72267bf7599ae358f0fb48da8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46ee21d95fb96184632d2560d88702ec16963b0080e1a1f76c8c7fc08d30fec9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0081653e128405d2aff492afb13b8bb59784871453142881f6b885f376e4c68b"
    sha256 cellar: :any_skip_relocation, ventura:        "573301ee4b89eef02b6c806be6c0105c06aedd4cec5373f268327ac0640e7d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "2a0b42fe89ee7ee2e2b31e480cba546fe3dbfa701e5a80641d8cc376bc698f8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e79dd411bbd4e5edda00083698bce0a1016b56cdbf19652321de642d50f69ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982bf29c252c2e921b3f1ad92ba9008bb75ed1719524f42695f7b153112e0713"
  end

  depends_on "python@3.11"
  depends_on "six"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec.glob("share/man/man1/trash*.1")
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
