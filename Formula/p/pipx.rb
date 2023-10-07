class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/86/4e/2820045417d94d699c7fcfc81860c9d671aed87fe563a00d9a5f88993c2f/pipx-1.2.0.tar.gz"
  sha256 "d1908041d24d525cafebeb177efb686133d719499cb55c54f596c95add579286"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af06c34c6621ad287f4a7450c12b4567da9fc1128829763f515124cd01271803"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a57e651b361d784c1ee4eddb62c5ba81b044942b602b7c7e908e3f111c1c284"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3cbcbcad6035e11cb4d191445139335f376f3ad392f65d880da49bbbe86f581"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c9d71e785cd5a0effc8c4efcfb94d33a6b31cedc19c2298b8e15dc51fc06d11"
    sha256 cellar: :any_skip_relocation, sonoma:         "db80cb8acb1acf0bcc834a7ddcb43810cffc9ff691f5a45a63cc6f1ff2b626f4"
    sha256 cellar: :any_skip_relocation, ventura:        "91e477d005dec847be8d458fb4550d750ee5c468c23a92445860992e24020231"
    sha256 cellar: :any_skip_relocation, monterey:       "41834ffcf2421615bc1a78f03997f15626f78fa000f2893458ebabe59477ab59"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea510e2636cdeb61c0e8128bc01166278db47ae6fab8d1cec05376a3bb2d7813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499bea282b4a69adbb11f61977da1429cbbe733065a48ca450f24361dfefee8b"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/1b/c5/fb934dda06057e182f8247b2b13a281552cf55ba2b8b4450f6e003d0469f/argcomplete-3.1.2.tar.gz"
    sha256 "d5d1e5efd41435260b8f85673b74ea2e883affcbec9f4230c582689e8e78251b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/4d/13/b8c47191994abd86cbdb256146dbd7bbabcaaa991984b720f68ccc857bfc/userpath-1.9.1.tar.gz"
    sha256 "ce8176728d98c914b6401781bf3b23fccd968d1647539c8788c7010375e02796"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/register-python-argcomplete"

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipx", "--shell",
                                         shells: [:bash, :fish])
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
