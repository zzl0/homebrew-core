class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/05/e9/f42b5233dc0d68c747d3dfc03ef191f3935211f9dedf66fa94e8ea9ac58f/autopep8-2.0.3.tar.gz"
  sha256 "ba4901621c7f94c6fce134437d577009886d5e3bfa46ee64e1d1d864a5b93cc2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9876c8ccc7e08dd15b048a996d0f460b993da7c3d8092c73b08d14412e47a935"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9876c8ccc7e08dd15b048a996d0f460b993da7c3d8092c73b08d14412e47a935"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9876c8ccc7e08dd15b048a996d0f460b993da7c3d8092c73b08d14412e47a935"
    sha256 cellar: :any_skip_relocation, ventura:        "5aba6fbd91b8a69fa0fbf8c23e1b1aba93a7bf0e11a8f3de2f77702f068c6233"
    sha256 cellar: :any_skip_relocation, monterey:       "5aba6fbd91b8a69fa0fbf8c23e1b1aba93a7bf0e11a8f3de2f77702f068c6233"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aba6fbd91b8a69fa0fbf8c23e1b1aba93a7bf0e11a8f3de2f77702f068c6233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd2c70a4d66684833df256b1c1ede1240b09c9c89e434ead620840ed0c3d332f"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pycodestyle" do
    url "https://github.com/PyCQA/pycodestyle/archive/2.11.0.tar.gz"
    sha256 "757a3dba55dce2ae8b01fe7b46c20cd1e4c0fe794fe6119bce66b942f35e2db0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
