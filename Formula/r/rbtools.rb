class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/19/ef/8900501b1af41d2485ee1eabb9f3e309f80fdae911c97927d8917ae99f9f/RBTools-4.1.tar.gz"
  sha256 "24efb20346b905c9be0464e747ee1bdee7967d1b94175697ea0c830d929475ff"
  license "MIT"
  revision 1
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75515d822f030e47fd926bfe50675b25920355f22fcfbcf3034682b3fba2563f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "277a8c9af0ce8eff57a90be5d471f1f298346a0d144781a17baa9da5ea30cb32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70763493e72f7e536b0ee744f5bcab7f00c934256dcfe3681a7a3f9889007511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3975e2c094222e09d0e823c8b5b938ae78de2c6df87b34741d57aface87ab6ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d86684678559666e2577ccb202b3ac6eedf6eef35568d12c410a08f58f96ef8"
    sha256 cellar: :any_skip_relocation, ventura:        "707850961f0e3b3af1a94bc5d98ac6abc13069fc2afb7e992924175afce5e88f"
    sha256 cellar: :any_skip_relocation, monterey:       "e98985956bb0b4573159d598214c483d7d81f7b26b20d59de0085ffac4af0111"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7c2ea19f3c55d15ed017df33afa0ed3d3396924f4eea5be9e3adb87f4b8abff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d92a1cba0e02a05828924fa6951e3e553a2d6cf18292d11401b35a6741a9c1c7"
  end

  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "pydiffx" do
    url "https://files.pythonhosted.org/packages/d3/76/ad0677d82b7c75deb4da63151d463a9f90e97f3817b83f4e3f74034eb384/pydiffx-1.1.tar.gz"
    sha256 "0986dbb0a87cbf79e244e2f1c0e2b696d8e86b3861ea2955757a61d38e139228"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install "rbtools/commands/conf/rbt-bash-completion" => "rbt"
    zsh_completion.install "rbtools/commands/conf/_rbt-zsh-completion" => "_rbt"
  end

  test do
    system "git", "init"
    system "#{bin}/rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end
