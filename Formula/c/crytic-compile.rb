class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/76/07/b629a6bf2c56f63bb6cd1b2000e58395642dcd72ebae746282a58c0feb3f/crytic-compile-0.3.6.tar.gz"
  sha256 "9a53c8913daadfd0f67e288acbe9e74130fe52cc344849925e6e969abc1b8340"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bbc9a7933f163dc36195299a9b6cbba265f7f3a30e8fb04774550abe921b07d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddea1230595d14484cc120b51099d904d46ac2439531b3da655dd4dd613abfb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef090f529d4ebfbd9196dd3cbcafaea07468b3b572be67f4aa4b6c9ecbec43f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a18f19780b9da39b1a2a81bc06fa2d4822e2072ab8d192e50de947bf5107ddb"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f2fc9d8bc6c5eaa1c2428ea334ed2f68b603633d755c8785d3d3b6bbd88bec"
    sha256 cellar: :any_skip_relocation, monterey:       "a61e6190a45a619f4e9293854061c83c93ac1c8bc888b2014fb633c6616cb7f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1e554ce1235c086e6f15fc183885f765e6c7a1766caabfcf0f12e216873ea78"
  end

  depends_on "python-setuptools"
  depends_on "python-toml"
  depends_on "python@3.12"
  depends_on "solc-select"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/bb/66/b09bf8421645852616044d3de9e632e1131c059f928a53bf46b1bc08e3ec/cbor2-5.6.0.tar.gz"
    sha256 "9d94e2226f8f5792fdba5ab20e07b9bfe02e76c10c3ca126418cd4310439d002"
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
      system bin/"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip",
             "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_predicate testpath/"export/combined_solc.json", :exist?
  end
end
