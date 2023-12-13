class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/3f/dc/118d1dfd22e5274f3cc341cb3c92b128dba6c47d2c8749d213bf6b7d1e16/ptpython-3.0.24.tar.gz"
  sha256 "6bc48211c0f6b5fc1ccfe617485167070311d7c79014eb9c06984e90802b54b0"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5668b3276190016049f1f56434f713589acd04ef15cbe2fa3338c0af70115e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0d1734dfef412ef13543e4bae65d4b5c4e63304f464852d4ef0e7f889ace027"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a192aaa9a90f68f740390325c49dcf6bcb2e0f8f10725ba1d530600ee3b8d488"
    sha256 cellar: :any_skip_relocation, sonoma:         "91e129e2b07d7eb2a9097946253b3a39d44019f077c5a6e887cc14d50bf04d1a"
    sha256 cellar: :any_skip_relocation, ventura:        "dfb005dcac1713b9ce4e5e32e6580aacb1de4c92fa69b456b3c095627fd252b6"
    sha256 cellar: :any_skip_relocation, monterey:       "3de71ce40f8d3f23e3260d8660d2d5eff88c2838b57a49f6e06c22fd8c634d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789290737f8f5d0762cb884a70ba4f7e8b8b5d320bf3857b8b92c10b34712c6e"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/d6/99/99b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0a/jedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end
