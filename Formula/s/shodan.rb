class Shodan < Formula
  include Language::Python::Virtualenv

  desc "Python library and command-line utility for Shodan"
  homepage "https://cli.shodan.io"
  url "https://files.pythonhosted.org/packages/0c/b8/60c2a98f767fb991ba9452551639e8a43db9269af860feac259e636e0719/shodan-1.30.1.tar.gz"
  sha256 "bedb6e8c2b4459592c1bc17b4d4b57dab0cb58a455ad589ee26a6304242cd505"
  license "MIT"
  revision 1
  head "https://github.com/achillean/shodan-python.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e10112522d0eca1d201fa7f05715fc662e5ee571891ae98b23abb753f5a721b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a1f155722558fa95ccfc6668ccd1ab985cf64a62d7274717e3861f7d96ab4ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ec5df864c60facd25ca92abbcf95895d80343b0accffc0448d56c9e45a42c7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9f6bb6ed5951d30c86fa00c58077b86ff65c21ea1ea1caf6ca79c18fde0b6a0"
    sha256 cellar: :any_skip_relocation, ventura:        "b86f05f5957dd3af2c2780153aa79b8ac20959273aa4bd33224b3e9456dd4b32"
    sha256 cellar: :any_skip_relocation, monterey:       "d2f2bb1110bce7cda4daae51a9775a0544e4a7b6585b8541c8ebad7e9aab4430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc117ef75a836bb9d72852a9abedbaf9ce5eaace8ae925d5c4abe2814b687ef5"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/ed/41/0a06e38f7fb55a3a2abaf998e018ed7d22987c0f1abbbcc1d50e06975b4f/tldextract-5.0.1.tar.gz"
    sha256 "ac1c5daa02616e9c2608f5fb6dd93049db03d0cf46c7f6fad46e2850a984f019"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/da/b3/90e50e5c285f48b5fc251a6e8ec255a110dc194349b992a18c5b9ae3e713/XlsxWriter-3.1.8.tar.gz"
    sha256 "059d0786fbfa3055588e81e9d5acf4ace28394bf09353a31ae2cae635740fc15"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shodan version")

    output = shell_output("#{bin}/shodan init 2>&1", 2)
    assert_match "Error: Missing argument '<api key>'.", output
  end
end
