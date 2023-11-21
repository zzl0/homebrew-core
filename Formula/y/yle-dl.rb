class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/0a/b5/ec7799b29199420b8263526dba8cafe6a4a57de70086453291244b25596c/yle_dl-20231120.tar.gz"
  sha256 "35a0a077c32184ee993ef953ec9a74098399b3094009d562cc3638470d745218"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "feb42ca73c015f9738709e7232236d781c5a4f2b790db81a8fbc9dcf52b83f71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db003723acb3814dd3b248b857cded5ddc2f0011c286cf27fd313e42f5501af1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b15fdfb2915820acc81ea830cb00d5c99b04c5ed6ef06b141ec824e317da09a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "69120db822740dcdc862336c8ac2b5197e1e64ae456b8732d1588cdbf79caebb"
    sha256 cellar: :any_skip_relocation, ventura:        "033f9cb639850c714c1cc137de380b1360eb6a5a90180a522a7d381c8e381f9b"
    sha256 cellar: :any_skip_relocation, monterey:       "c91f260fd26270155ce6e20fc779c01c9d6903a0ece2b6051515fa8aa885080a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03b20dfd742dfd4ef2238a28cfa84c35edaabbf91308339c8573820bbbe24ee9"
  end

  depends_on "cffi"
  depends_on "ffmpeg"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
