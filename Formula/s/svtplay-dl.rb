class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/0e/25/fad5ab27c425b4cf2c37bd986999af94b8c922752f0bc21b4ee917112fbe/svtplay-dl-4.69.tar.gz"
  sha256 "baa3dcfabb786b4c883bcebcf9a0406ea5dba25d35e555b0391da8a42883e0f8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a197cab5e1e821db1014e25de5410c0cf26db587545507b3d42dcb25311ee70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b21ec0a26f99c7915c6d8dda9228e03d369e4a2cc8734bb8a189e7067dd58e1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1306a44b56392036db34860a5a8cc709b94bff2e514c9c6246f541a313c3170"
    sha256 cellar: :any_skip_relocation, sonoma:         "60cd0da0da181f60dc0f9bdcb7e292f7499999b733b56d9db1c19ad8c0c90d5e"
    sha256 cellar: :any_skip_relocation, ventura:        "e7ae851a17a2b9e691429d4cff17aa2acc9597cd8a4fb2c0d22bc86546584788"
    sha256 cellar: :any_skip_relocation, monterey:       "5de8bbc7529078e3c3b766317cd6760f6e1a2ae1e906ae9a199ec947aded9436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "968980f91f4bf8abec6068e22fb60c72a38be68c6d00a93616192e91f72b61bd"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
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

  def caveats
    <<~EOS
      To use post-processing options:
        `brew install ffmpeg` or `brew install libav`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/video/357803"
    match = "https://amd-ab.akamaized.net/ab/vod/2023/07/64b249d222f325d618162f76/720_3500_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
