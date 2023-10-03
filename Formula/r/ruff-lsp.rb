class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/57/f0/e97753c41d07f90a3df653fe885c0ede54734e232728365e068573aaaa9b/ruff_lsp-0.0.40.tar.gz"
  sha256 "15e7b4a500a11cca34040348a689830ea5739dc2edb0ad51a05deec293bfacf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4f309ea68ae0d340efd2e58ca92752cc6bca7503c18ed5d18a90613feb63338"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc8c5627a6f33240c38feadfc0f4026f8664df730b2f6d8b9fe649afa02e3ba5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c17956893524120c3c96a56477bbdfc4fc7c6207c114489d1f8b26ebe426fd09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fd1cc0963223c61dab983dacaf1bb8902cdec6217fe657f542e9702832445a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "29874af4a5a5f7b5bff32a0821d3d363ce466a85197db5da94763eb013896af0"
    sha256 cellar: :any_skip_relocation, ventura:        "eb695f0022471e29b72696c734a34059d61bc2e8d1113f01838f3435e30763a6"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1e2cbeeb04c590be5cfdf81d55dc75929f687a688dbe4ec53d049b87f0a664"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0f99f778460c815d2b96f4a49348cedd993d007b3a05c715075f64714f265c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1afb02d215293725b2addc5c7994947457e3120147265582008303ee4aac42"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "ruff"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/68/d4/27f9fd840e74d51b6d6a024d39ff495b56ffde71d28eb82758b7b85d0617/cattrs-23.1.2.tar.gz"
    sha256 "db1c821b8c537382b2c7c66678c3790091ca0275ac486c76f3c8f3920e83c657"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/22/a1/4df53bbe3663de65ad90c6bbc2e6e8779b61fba1e13ee9a21a0f2f7db8f9/lsprotocol-2023.0.0b1.tar.gz"
    sha256 "f7a2d4655cbd5639f373ddd1789807450c543341fa0a32b064ad30dbb9f510d4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/10/1a/4994d487a7295a7c834a81003b83b00b26086dbd3747699ed3eb20e73fcc/pygls-1.1.0.tar.gz"
    sha256 "eb19b818039d3d705ec8adbcdf5809a93af925f30cd7a3f3b7573479079ba00e"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/af/40/3398497c6e6951c92abaf933492d6633e7ac4df0bfc9d81f304b3f977f15/typeguard-3.0.2.tar.gz"
    sha256 "fee5297fdb28f8e9efcb8142b5ee219e02375509cd77ea9d270b5af826358d5a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/ruff-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
