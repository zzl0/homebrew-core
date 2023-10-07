class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/55/32/beede58634c85d82b92139a64e514718e4af914461c5477d5779c4e9b6c4/cppman-0.5.6.tar.gz"
  sha256 "3cd1a6bcea268a496b4c4f4f8e43ca011c419270b24d881317903300a1d5e9e0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "846f2de8903994f5383601ff8539bc83469dd12eab008c3ecc65914ba7e618f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85ce804f79cc3df74fb57f78cb83d260b0f6d3cd7bf2eeb593441a9898c7bba3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "529031e649ee5929ff3d2c4e191eecf8b1b78996d926c25695a26a1e22328d24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ef54048e0c3f56e7fc643a8299c520022a79d72647e599498f300ae020586e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b7575164b4b72fb79560377d79a1021e7c6b3c452d488ab8653e9824695f5e3"
    sha256 cellar: :any_skip_relocation, ventura:        "00ef1e771cab08185d25dcb0eec05ba2b07bd0cc89cbcbf81a065fa2ab75e6d6"
    sha256 cellar: :any_skip_relocation, monterey:       "52726dea84aa5115e17cc55ee8642046b677929e089b2f08fb2d0b2bdb1dbb43"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbbd8842697830a91f72c4c656656b25f889f94ba850d39368232d8d3cb549fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c41839f27bc0c92851d41f65c992d191cacd140b22047c373001fc4b83e6f952"
  end

  depends_on "python@3.12"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "std::extent", shell_output("#{bin}/cppman -f :extent")
  end
end
