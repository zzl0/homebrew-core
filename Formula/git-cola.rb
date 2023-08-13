class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/c2/1c/25d293f113d6091412ac5dbe2eee56bad5ba97c7a4ce0ca25df91c0c3eb8/git-cola-4.3.0.tar.gz"
  sha256 "fcf8ad0886660f5bc957878655648e0701c092d0aba2ae1e8f82c73562ab874b"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "132fc9104b54d56fcbb3e6c05e8971487641dca460b189094a131b4c0595d04e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fbf971068f677d8689b2ea250f9904757b67ec6f24859b789f45498d67a2040"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fe3b8bdd3d8d7ac87b82686943ee84599d75b65b4a8c5e9e608102fad1099d6"
    sha256 cellar: :any_skip_relocation, ventura:        "44f3a73733e5e6de836969b2d050ca7c6c54d0fcbfb9ee863ce6208086988181"
    sha256 cellar: :any_skip_relocation, monterey:       "af93e14f3ed6e42f871d8f9110b49f1dd1e0340e39fd195dcfd40be7ae52c0dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "52acf5960546c38af6414804f0bd6de60bccefa2a093cd307a974bd02349812c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88fda1fe2446c397c6953fb574f740d3d3dfec76589a83b3a1cac4033fbeb8d1"
  end

  depends_on "pyqt@5"
  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "QtPy" do
    url "https://files.pythonhosted.org/packages/ad/6b/0e753af1197f82d2359c9aa91cef8abaaef4c547396ffdc71ea6a889e52c/QtPy-2.3.1.tar.gz"
    sha256 "a8c74982d6d172ce124d80cafd39653df78989683f760f2281ba91a6e7b9de8b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
