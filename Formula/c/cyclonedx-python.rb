class CyclonedxPython < Formula
  include Language::Python::Virtualenv

  desc "Creates CycloneDX Software Bill of Materials (SBOM) from Python projects"
  homepage "https://cyclonedx.org/"
  url "https://files.pythonhosted.org/packages/71/fa/9a91b4dfb61bed3ad2ddcd836693a66c476b45fa24eaa6627f8b26cb79ff/cyclonedx_bom-3.11.6.tar.gz"
  sha256 "b358625adfbe0c4a3aee3ea48f52718c9f97ec75ec55fa7f536e41fd1a514f48"
  license "Apache-2.0"
  head "https://github.com/CycloneDX/cyclonedx-python.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7ae3a0384c36a6550ddb8be989c730ec3ea6a44fca14b288f8f51d8639e5d90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3f494e1b0051230f5ec92fc10c64511f6ef95fcd44e08580510321b328d06e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "387cc56d0624afdee81008c0b50050ad8550bb0eae2ab73cb417a76ca6001c90"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ff34f9801ef6f2c9353c90e33c69a5891e22c7db6993480b72d5b4264fda87c"
    sha256 cellar: :any_skip_relocation, ventura:        "fd9d11c4faf8ac7b402cbcea05427ec5e91e8e7a662ccd2677b84b75791b889a"
    sha256 cellar: :any_skip_relocation, monterey:       "567e6e1189cd9b20e9090843e7e4831c0bd3c567dc5e04c5d32adf999f911a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea561e313ff594ad4bbebdc1908fdb991c8063ea22f91ebf5cd27b43353ac4dc"
  end

  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python-setuptools"
  depends_on "python-toml"
  depends_on "python@3.12"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/dd/0d/2d77978ff3ebe445c00ffc209eb205d126ef7a8ece69e7f3d014e561bada/cyclonedx_python_lib-3.1.5.tar.gz"
    sha256 "1ccd482024a30b95c4fffb3fe567a9df97b705f34c1075f8abde8537867600c3"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/33/34/a7843f732e1e0b01e961f6ae835b3fd6bd4e361c1a3a72debd31244cb718/packageurl-python-0.11.2.tar.gz"
    sha256 "01fbf74a41ef85cf413f1ede529a1411f658bda66ed22d45d27280ad9ceba471"
  end

  resource "pip-requirements-parser" do
    url "https://files.pythonhosted.org/packages/5e/2a/63b574101850e7f7b306ddbdb02cb294380d37948140eecd468fae392b54/pip-requirements-parser-32.0.1.tar.gz"
    sha256 "b4fa3a7a0be38243123cf9d1f3518da10c51bdb165a2b2985566247f9155a7d3"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"requirements.txt").write <<~EOS
      requests==2.31.0
    EOS
    system bin/"cyclonedx-py", "-r", "-i", testpath/"requirements.txt"
    assert_match "pkg:pypi/requests@2.31.0", (testpath/"cyclonedx.xml").read
  end
end
