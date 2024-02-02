class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/ce/e2/eb9b7d3ab17b0192f606faf67a69826dfb755e9ab97697e7dcaf952a50db/ruff_lsp-0.0.51.tar.gz"
  sha256 "6411486a0c304d44153c09dca2636d84c692d206799ee61c4942981d2c503eb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c432b01a130e2662aa6f5360af4b68099248c324fbd72674d4347e54affd2440"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cabd668a1d6511034d0bb4625eafebb8335b80333a267fe1ceea8017128506ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76c674af7f2440c59de2af4f166c130df573a3348b0959e3cc2ea7f7180f2a0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f1e576315ee22c17c68b961c7b2ea5078545f70085d4e9a25f1c642fd7a5922"
    sha256 cellar: :any_skip_relocation, ventura:        "c2d9abb1a1d765780f64eff5d816fe12239d2c5431fbefccbe1cb4c0b62003a0"
    sha256 cellar: :any_skip_relocation, monterey:       "3e1300bf057dee6b331247026a639cf2836b6792482883aefb4d6f34d59b1ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b03cc54611e272e1df0ca70aaf8d011937f8dd16cd0c17f53176a0562b2615"
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
    url "https://files.pythonhosted.org/packages/9d/f6/6e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6f/lsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/e9/8d/31b50ac0879464049d744a1ddf00dc6474433eb55d40fa0c8e8510591ad2/pygls-1.3.0.tar.gz"
    sha256 "1b44ace89c9382437a717534f490eadc6fda7c0c6c16ac1eaaf5568e345e4fb8"
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
