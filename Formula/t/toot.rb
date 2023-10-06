class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https://toot.bezdomni.net/"
  url "https://files.pythonhosted.org/packages/4c/55/f7c6578f031e1c5d6605c1977ea36a9d7b89a72aef79b93fbd9719a15a74/toot-0.38.1.tar.gz"
  sha256 "be9e5479a21ea8fb13cf7ba98d542daae07fd87fb56b20b8923b69ffa521c6b2"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/ihabunek/toot.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75bda65a1f381b5cf5d52f5874e1b5c62415362a351a42b846651f616bd287d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17a7dbd166167a09a52e7c2d45e8288d8e06e16ae4b9fe86fd4ec666680ffc41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e17338f76dbd549882bd9f3062abff662eeb0b5243e2c0cac8203dfdd7413f8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "546603f95616c539116a91f1f7008a24f2b0ec4adcb9740ad141598ee717a515"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ddd3af29ee3bb9ffd13e23ff3637281a4fc4344b59d9e00286481c68182c66d"
    sha256 cellar: :any_skip_relocation, ventura:        "d11bff20289b2910be00e4868e7dd4b92062fea533d2225ded1e108ceda7130b"
    sha256 cellar: :any_skip_relocation, monterey:       "67fc899488859cbc3e6f935ae7eb3df86d20bc711de07b4d765fdc34599045a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd48c86a0793dabb210e3ca16e5e7bf9bb480cc205a7313679663d5e6b05cedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "085ff020ab583f26042053be48ea8d26f67da45f2749fd38757f90d99114bc9f"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/5f/cf/2f01d2231e7fb52bd8190954b6165c89baa17e713c690bdb2dfea1dcd25d/urwid-2.2.2.tar.gz"
    sha256 "5f83b241c1cbf3ec6c4b8c6b908127e0c9ad7481c5d3145639524157fc4e1744"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toot")
    assert_match "You are not logged in to any accounts", shell_output("#{bin}/toot auth")
  end
end
