class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/9f/94/33db7ee5edc9935a21a79c79d1dba7b08b93c8de97b29e98c43ed64053e8/ruff_lsp-0.0.49.tar.gz"
  sha256 "dc18046d7fdc81477435fe7b58407ba13964d2d1b67b8cd337d280f47dc405f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5715fd7286aa2edf22800ecb6190d8af48b567015b0b33e679b6af79d75ed6e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c28038ce9bece910242db58a80a0b1e8e09e62951353401cffbcde90df129c29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a5f4ae681e489dde3627984fd3e6d71f354a10f78292f296dd8f46d02f3a817"
    sha256 cellar: :any_skip_relocation, sonoma:         "0181bf814ddce0da994c701a7a689ed5989d7e16cfa3b29f2b7928946407142b"
    sha256 cellar: :any_skip_relocation, ventura:        "8f4e37754a06ee174252043b12a4cce8308830ab9ab8cdbf1a7e4120f8c8dd00"
    sha256 cellar: :any_skip_relocation, monterey:       "b8736c7636328ee9d1fc5ee3f4fc17e7165e6a4306f589ea9003b62f54ed99a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ab5782b418a46a21160b55ea95573cec79e299099a972c8f4b006da0ef59694"
  end

  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "ruff"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/1e/57/c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284/cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/3e/fe/f7671a4fb28606ff1663bba60aff6af21b1e43a977c74c33db13cb83680f/lsprotocol-2023.0.0.tar.gz"
    sha256 "c9d92e12a3f4ed9317d3068226592860aab5357d93cf5b2451dc244eee8f35f2"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/e6/94/534c11ba5475df09542e48d751a66e0448d52bbbb92cbef5541deef7760d/pygls-1.2.1.tar.gz"
    sha256 "04f9b9c115b622dcc346fb390289066565343d60245a424eca77cb429b911ed8"
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
