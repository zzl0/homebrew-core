class Textract < Formula
  include Language::Python::Virtualenv

  desc "Extract text from various different types of files"
  homepage "https://textract.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/81/9f/dd29fcec368f007d44e51f0273489d5172a6d32ed9c796df5054fbb31c9f/textract-1.6.5.tar.gz"
  sha256 "68f0f09056885821e6c43d8538987518daa94057c306679f2857cc5ee66ad850"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5f5c391f5615d5e4abb0f087a2cf5e579b0287966850854dc39b6ebbf183547"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f67ebdc7dcc9ee9adcec6105e16a8cc93c318381a2c5a66c6f25e86dbe0d83fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1f3082bd34fd108c69dc582d4c9aa0c3767f9ceaf436bbf66eaa089903de4da"
    sha256 cellar: :any_skip_relocation, ventura:        "5d520a4c97bd11a66a0e000d34b739d39b33782066f79f4bdcf161b378797d20"
    sha256 cellar: :any_skip_relocation, monterey:       "bbc1ba9f604222a44dd12258cb8a2749c230892c201c497bd0a5f89ac0252309"
    sha256 cellar: :any_skip_relocation, big_sur:        "318532dfba7140276340128ada24a8e6790eaf2c8f40edf30893022f598b7a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f34dffd7f6facfcbc1ad72802cf799d6e0d8921a0a1151d397a922665935d067"
  end

  depends_on "antiword"
  depends_on "flac"
  depends_on "pillow"
  depends_on "poppler"
  depends_on "python-setuptools" # for `distutils`
  depends_on "python@3.12"
  depends_on "six"
  depends_on "swig"
  depends_on "tesseract"
  depends_on "unrtf"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/ae/28/07d2cfe0838f998ea2eafab59f52b0ceb1e70adb1831fa14b958a9fa6c5c/argcomplete-1.10.3.tar.gz"
    sha256 "a37f522cf3b6a34abddfedb61c4546f60023b3799b22d1cd971eacdc0861530a"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "compressed-rtf" do
    url "https://files.pythonhosted.org/packages/8e/ac/abb196bb0b42a239d605fe97c314c3312374749013a07da4e6e0408f223c/compressed_rtf-1.0.6.tar.gz"
    sha256 "c1c827f1d124d24608981a56e8b8691eb1f2a69a78ccad6440e7d92fde1781dd"
  end

  resource "docx2txt" do
    url "https://files.pythonhosted.org/packages/7d/7d/60ee3f2b16d9bfdfa72e8599470a2c1a5b759cb113c6fe1006be28359327/docx2txt-0.8.tar.gz"
    sha256 "2c06d98d7cfe2d3947e5760a57d924e3ff07745b379c8737723922e7009236e5"
  end

  resource "ebcdic" do
    url "https://github.com/roskakori/CodecMapper/archive/refs/tags/v1.1.1.tar.gz"
    sha256 "7a1a77fdc7e87924e42826087bd9c0c4b48b779156c10cabc94eec237739c818"
  end

  resource "extract-msg" do
    url "https://files.pythonhosted.org/packages/67/fb/ed86f4fa53e58e90598f635bba9b4140a20992bd968aaaf8ae1fbacd6e57/extract_msg-0.28.7.tar.gz"
    sha256 "7ebdbd7863a3699080a69f71ec0cd30ed9bfee70bad9acc6a8e6abe9523c78c0"
  end

  resource "imapclient" do
    url "https://files.pythonhosted.org/packages/ea/31/883f78210ed7578f6dd41e4dbc3ad5e7c6127a51e56513b8b7bb7efdf9b3/IMAPClient-2.1.0.zip"
    sha256 "60ba79758cc9f13ec910d7a3df9acaaf2bb6c458720d9a02ec33a41352fd1b99"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "olefile" do
    url "https://files.pythonhosted.org/packages/69/1b/077b508e3e500e1629d366249c3ccb32f95e50258b231705c09e3c7a4366/olefile-0.47.zip"
    sha256 "599383381a0bf3dfbd932ca0ca6515acd174ed48870cbf7fee123d698c192c1c"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/e8/31/7acc148333749d6a8ef7cbf25902bdf59a462811a69d040a9a259916b6bd/pdfminer.six-20191110.tar.gz"
    sha256 "141a53ec491bee6d45bf9b2c7f82601426fb5d32636bcf6b9c8a8f3b6431fea6"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/ed/19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239/pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "python-pptx" do
    url "https://files.pythonhosted.org/packages/20/e7/aeaf794b2d440da609684494075e64cfada248026ecb265807d0668cdd00/python-pptx-0.6.23.tar.gz"
    sha256 "587497ff28e779ab18dbb074f6d4052893c85dedc95ed75df319364f331fedee"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "SpeechRecognition" do
    # not available on PyPI; see https://github.com/Uberi/speech_recognition/issues/580
    url "https://github.com/Uberi/speech_recognition/archive/refs/tags/3.8.1.tar.gz"
    sha256 "82d3313db383409ddaf3e42625fb0c3518231a1feb5e2ed5473b10b3d5ece7bd"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "xlrd" do
    url "https://files.pythonhosted.org/packages/aa/05/ec9d4fcbbb74bbf4da9f622b3b61aec541e4eccf31d3c60c5422ec027ce2/xlrd-1.2.0.tar.gz"
    sha256 "546eb36cee8db40c3eaa46c351e67ffee6eeb5fa2650b71bc4c758a29a1b29b2"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/2b/a3/dd02e3559b2c785d2357c3752cc191d750a280ff3cb02fa7c2a8f87523c3/XlsxWriter-3.1.9.tar.gz"
    sha256 "de810bf328c6a4550f4ffd6b0b34972aeb7ffcf40f3d285a0413734f9b63a929"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| r.name == "ebcdic" }
    resource("ebcdic").stage { venv.pip_install "ebcdic" }
    # delete SpeechRecognition's flac binaries that our `flac` formula provides
    rm libexec.glob("lib/python*.*/site-packages/speech_recognition/flac*")

    # https://github.com/deanmalmgren/textract/issues/476
    inreplace "requirements/python", "extract-msg<=0.29.*", "extract-msg<0.30"
    venv.pip_install_and_link buildpath
  end

  test do
    cp test_fixtures("test.pdf"), "test.pdf"
    pdf_output = shell_output("#{bin}/textract test.pdf")
    assert_includes pdf_output, "Homebrew test."
  end
end
