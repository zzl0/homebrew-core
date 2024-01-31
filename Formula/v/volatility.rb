class Volatility < Formula
  include Language::Python::Virtualenv

  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility3"
  url "https://files.pythonhosted.org/packages/b1/4a/18f068948a7156ee733c6ea42ef8a201421931568b3b83b49a381a477ab2/volatility3-2.5.2.tar.gz"
  sha256 "63716fa9ad29686c6d25471eaaf58380df1bd508b827de7ef9ada63bda6d8e76"
  license :cannot_represent
  version_scheme 1
  head "https://github.com/volatilityfoundation/volatility3.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "34ca02a6d0506021c1e54eb639436493e29cd6e7d2d498ca7eb4e50cc99628f9"
    sha256 cellar: :any,                 arm64_ventura:  "5009e530a9fd882e007cb87d9b99b91d1c209242c699441706ae6c9a645480bc"
    sha256 cellar: :any,                 arm64_monterey: "6cdcf08126d23419af6e0b774cbc4e3dfcbff93406ed3210540f96724519d071"
    sha256 cellar: :any,                 sonoma:         "294c2c90a5b75ebdf70861c56a5e44ca867f70f47745601dde893d68550f99ab"
    sha256 cellar: :any,                 ventura:        "bb952b75ac94871a7233ae60340be3a6d302ff04a50036eea38c460e6df53dc1"
    sha256 cellar: :any,                 monterey:       "01038a65424ee7626e388d07f917415f42b8bb4f9b424792052817ef496cb76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5925d6c47de8804ac7b56fa708fcb94b42c60a092fd006232ab065a0e2a057c2"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "yara"

  # Extra resources are from `requirements.txt`: https://github.com/volatilityfoundation/volatility3#requirements
  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/7a/fe/e6cdc4ad6e0d9603fa662d1ccba6301c0cb762a1c90a42c7146a538c24e9/capstone-5.0.1.tar.gz"
    sha256 "740afacc29861db591316beefe30df382c4da08dcb0345a0d10f0cac4f8b1ee2"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/4d/c5/3f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9be/jsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/78/c5/3b3c62223f72e2360737fd2a57c30e5b2adecd85e70276879609a7403334/pefile-2023.2.7.tar.gz"
    sha256 "82e6114004b3d6911c77c3953e3838654b04511b8b66e8583db70c65998017dc"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/ed/19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239/pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/21/c5/b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9a/referencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/b7/0a/e3bdcc977e6db3bf32a3f42172f583adfa7c3604091a03d512333e0161fe/rpds_py-0.17.1.tar.gz"
    sha256 "0210b2668f24c078307260bf88bdac9d6f1093635df5123789bfee4d8d7fc8e7"
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
