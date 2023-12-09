class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/23/c1/cab449bf8cd1541ad32617061accd4f4150ef2e906f0fe7cac9054dd91cd/sigma_cli-0.7.11.tar.gz"
  sha256 "9337ec46b46cfdbea262a439e90df58a83319df33f4339c965cb6b7b318cd5b8"
  license "LGPL-2.1-or-later"
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9b850682be17310ea370d915d63331a178c441a3dfd72c42e87c94b9011e634"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcaf44fe28fd929cd196a02f19f677cff74484cf77b038d582ac6a8df66a004f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bc8ebaa7334998bafb1bb2398a144e26b37b629881655c19f836599795f1547"
    sha256 cellar: :any_skip_relocation, sonoma:         "538dd896687df373890442153fab1c0e398397c73f26bed4040061ae40adbcde"
    sha256 cellar: :any_skip_relocation, ventura:        "3e9d873683b01abc3eaf80ec32b2b2638af82a6c34bd77584e5703344a8ffd3d"
    sha256 cellar: :any_skip_relocation, monterey:       "5d9eeb3f36e3b8bfe88ae12f9ea2138dd01db7e59da27a8521b67f5bf4d96b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbb31fdd73eb89a6b3b2f325e8ba8fb37a5551528f50326aaa53fa5004cda7b6"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e1/c0/5e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386b/prettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "pysigma" do
    url "https://files.pythonhosted.org/packages/17/06/db5dba338b198b8932f0aff42fe76d1fb989b68be8fc1e39eb5b38ac2568/pysigma-0.10.9.tar.gz"
    sha256 "aa498c9b6daafcfd0001e6f7b78e6f9c04302b8bc18e8c486eb54197982b248d"
  end

  resource "pysigma-backend-sqlite" do
    url "https://files.pythonhosted.org/packages/b6/13/144274ca0f2d721e79360e309b062a3a765cecdc87c03d2a893430e00454/pysigma_backend_sqlite-0.1.0.tar.gz"
    sha256 "0ff6f8029a5e4de7d31e30916f073f23422091da5e204653ac7272483f513521"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigma version")

    output = shell_output("#{bin}/sigma plugin install sqlite")
    assert_match "Successfully installed plugin 'sqlite'", output
  end
end
