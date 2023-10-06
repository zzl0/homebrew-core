class Notifiers < Formula
  include Language::Python::Virtualenv

  desc "Easy way to send notifications"
  homepage "https://pypi.org/project/notifiers/"
  url "https://files.pythonhosted.org/packages/54/fc/aa5de032cc8d9ee41ceba7bbea98e2ed7090d7d95465dfe0179eb937146f/notifiers-1.3.3.tar.gz"
  sha256 "9fd8d95ab1ebcd3852423755aa90cbb0f72a805ca77af0d8c9ad7af445f58399"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "deb3c09a6c8c78e4aff431ec584c1bde0d10ccb4cb16be907aae38127b24d6f6"
    sha256 cellar: :any,                 arm64_ventura:  "37f36d2c5a00f4813f572f1b266bacae7d3e661cd3541744182d9a585da2a411"
    sha256 cellar: :any,                 arm64_monterey: "a617f82423428f57dc6f45845e56cc8ebeaa9ba6195ca3d5c00463052c94ed3a"
    sha256 cellar: :any,                 arm64_big_sur:  "c1c6131264960fea4932e136387ddd11d3abf3da10b561538ea73f0adf10565f"
    sha256 cellar: :any,                 sonoma:         "7dd3e533749c147708ec901ce9d9b03cf50122c1fedb32b0f11e27370cbb20fd"
    sha256 cellar: :any,                 ventura:        "73fc8b2c03048a228dd4a699ab2252f181f50450c1741be5d082d1ca8051ef6b"
    sha256 cellar: :any,                 monterey:       "0a39bfe48811b9a9bae8b00048971ee374c06999bccac5f1b5dec60ee625ef8d"
    sha256 cellar: :any,                 big_sur:        "64a96ad971f2f6e76fd0fa818ef84827c064005bf5a2f50cc2b3b85da52b5dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f69e07b0a5ca16f8e55bb17aa4b984aa936e39897bf2431ddb5f68531150595"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/e4/43/087b24516db11722c8687e0caf0f66c7785c0b1c51b0ab951dfde924e3f5/jsonschema-4.19.1.tar.gz"
    sha256 "ec84cc37cfa703ef7cd4928db24f9cb31428a5d0fa77747b8b51a847458e0bbf"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/e1/43/d3f6cf3e1ec9003520c5fb31dc363ee488c517f09402abd2a1c90df63bbb/referencing-0.30.2.tar.gz"
    sha256 "794ad8003c65938edcdbc027f1933215e0d0ccc0291e3ce20a4d87432b59efc0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/9e/a8/4a4e5ef90c4c4f27683ce2bb74b9521b5b1d06ac134cd650333fdca0f52c/rpds_py-0.10.4.tar.gz"
    sha256 "18d5ff7fbd305a1d564273e9eb22de83ae3cd9cd6329fddc8f12f6428a711a6a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "notifiers", shell_output("#{bin}/notifiers --help")
  end
end
