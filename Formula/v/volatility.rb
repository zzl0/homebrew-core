class Volatility < Formula
  include Language::Python::Virtualenv

  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility3"
  url "https://files.pythonhosted.org/packages/83/f6/be2fb46e5656f322eeb807a1b0d8a767561cec26824f275f8a3e29e4280c/volatility3-2.5.0.tar.gz"
  sha256 "278ec521c9213967a01321361e4d007c71e681a0c577a75710f482bfa15d0506"
  license :cannot_represent
  version_scheme 1
  head "https://github.com/volatilityfoundation/volatility3.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c538869fed9b1dbaa1d26426c0b35da2051f0dbf06059c74f81eec6661feb493"
    sha256 cellar: :any,                 arm64_ventura:  "84169fb0c2f5256739a5efbaacc20afdd6a2520d8a1fc75566bbea54aabe276f"
    sha256 cellar: :any,                 arm64_monterey: "278ef9645c21d5e6216c3ef14378a9ce948e08ecb73e7b35a7895443df4a1a69"
    sha256 cellar: :any,                 arm64_big_sur:  "28aa39120fd031bec31651009a78e57546067a4f97d033f72e7cafea9e97d765"
    sha256 cellar: :any,                 sonoma:         "77b56ffa37390b2eeb37f6cbb010767b5864ee0de6e670ce7ca5f2f6ceb8399f"
    sha256 cellar: :any,                 ventura:        "c1e75daf12354e2b7d76c0caf9715f6a6b606944a9ae5c3fa6868d116b7b03cb"
    sha256 cellar: :any,                 monterey:       "63eb9b1ee8ac526599759a7fbfc076f5a261439b06a1d62d814ad59ba259a9e5"
    sha256 cellar: :any,                 big_sur:        "dcb494ef9063ff0e44c1d893238526663555523b8a7aefeddc3853375e8fe49b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8764ec7aee8a099ef2bdb19c7d97220bd0e0f4ed469ffd17faf76b6c3c8cbcc9"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "openssl@3"
  depends_on "python@3.11"
  depends_on "yara"

  # Extra resources are from `requirements.txt`: https://github.com/volatilityfoundation/volatility3#requirements
  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/7a/fe/e6cdc4ad6e0d9603fa662d1ccba6301c0cb762a1c90a42c7146a538c24e9/capstone-5.0.1.tar.gz"
    sha256 "740afacc29861db591316beefe30df382c4da08dcb0345a0d10f0cac4f8b1ee2"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/e4/43/087b24516db11722c8687e0caf0f66c7785c0b1c51b0ab951dfde924e3f5/jsonschema-4.19.1.tar.gz"
    sha256 "ec84cc37cfa703ef7cd4928db24f9cb31428a5d0fa77747b8b51a847458e0bbf"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/78/c5/3b3c62223f72e2360737fd2a57c30e5b2adecd85e70276879609a7403334/pefile-2023.2.7.tar.gz"
    sha256 "82e6114004b3d6911c77c3953e3838654b04511b8b66e8583db70c65998017dc"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/1a/72/acc37a491b95849b51a2cced64df62aaff6a5c82d26aca10bc99dbda025b/pycryptodome-3.19.0.tar.gz"
    sha256 "bc35d463222cdb4dbebd35e0784155c81e161b9284e567e7e933d722e533331e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/52/fa/31c7210f4430317c890ed0c8713093843442a98d8a9cafd0333c0040dda4/rpds_py-0.10.3.tar.gz"
    sha256 "fcc1ebb7561a3e24a6588f7c6ded15d80aec22c66a070c757559b57b17ffd1cb"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/5f/34/60a293c7ae05731c2e6366e132a9fe4c02ae84c4f57714a2f5e8651a8491/yara-python-4.3.1.tar.gz"
    sha256 "7af4354ee0f1561f51fd01771a121d8d385b93bbc6138a25a38ce68aa6801c2c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"vol", "--help"
  end
end
