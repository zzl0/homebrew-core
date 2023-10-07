class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/3a/9c/e100d2dbc90471010716e56766ef6608717c44d7278eea3dacb5bb48276a/crytic-compile-0.3.5.tar.gz"
  sha256 "f9b2bf3dc8c99fbc58c4ae6f82b3e8e378f56e107e37fd8786a36567dd68fa6e"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fa40efded4dafd12df48484d6927ce9c6bd8465a5e1e34838becb7fdb50969f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8636132121c488a3363fc7f9a36be05f05913804d6328f10c9311042700eb8c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d603494d1a34ce2d19762865e71b88c5b9345a47b6b359a47233bca309298053"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b463daee590111792b834fe2e38a18ce5e823ebd49954f8f4e813c0bf1abdf2"
    sha256 cellar: :any_skip_relocation, ventura:        "29515a9e0deeae86de7802b9ceeb3b711f70d23c851cbd25da552778e7710dab"
    sha256 cellar: :any_skip_relocation, monterey:       "832ec029aa68f32b6f3bf7d54379e2d57d1be3f37b3fb73613cc83d8b054ce69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "896dcb009a5b771ad9b7f92cc0f94d7090e0f2e7744fdb2f9aa524f67c5412ac"
  end

  depends_on "python-setuptools"
  depends_on "python-toml"
  depends_on "python@3.12"
  depends_on "solc-select"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/69/de486293f5211d2e8fe1a19854e69f2811a18448162c52b48c67f8fbcac3/cbor2-5.4.6.tar.gz"
    sha256 "b893500db0fe033e570c3adc956af6eefc57e280026bd2d86fd53da9f1e594d7"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages("python3.12")
    solc_select = Formula["solc-select"].opt_libexec
    (libexec/site_packages/"homebrew-solc-select.pth").write solc_select/site_packages
  end

  test do
    resource "testdata" do
      url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      system bin/"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip", \
             "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_predicate testpath/"export/combined_solc.json", :exist?
  end
end
