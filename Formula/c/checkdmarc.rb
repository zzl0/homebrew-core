class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https://domainaware.github.io/checkdmarc/"
  url "https://files.pythonhosted.org/packages/b4/20/943f9774cd0e7832cd0800a2d86cd283bbf3dc8e43e4c1bb01e843fbf3e5/checkdmarc-5.0.0.tar.gz"
  sha256 "7f09e75d66ae8d510dfbe640489c29c14b87e6373f5a819201aa88a9cea25743"
  license "Apache-2.0"
  head "https://github.com/domainaware/checkdmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8eb1519279b68ca16966122a48d1a9c44f17acef9488e0bcab9ae61d7ce9c543"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2da69baa1bd3ebb1df0e0d21fbb88a23b1cb95056294d91f2e5745a95e17b1ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b095dfbf73a544fed51aee1a3123a47d0354046bc44aa98352b6e97518a545d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "255ea787ea3bedab2452ec0e7ac224530c759f1848ee20fb7b64745a6d4feca3"
    sha256 cellar: :any_skip_relocation, ventura:        "854e8c11e061df17e87209dbff6c16e3ea97f9df91b409c93397c90bd67faffa"
    sha256 cellar: :any_skip_relocation, monterey:       "0400f7ac46921b57cc6c1a85d86417fac85ff8cc7d75b2d0d13fcc12c6d81b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dba6e9f7c694f992126c9b454f4d319f167abe82133aab853bdb91da2f9e78d"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "expiringdict" do
    url "https://files.pythonhosted.org/packages/fc/62/c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7/expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/5d/c3/27cd98b1e3e4548de41f4cfdc9cacab42380f830d6ca38a37be890cffb06/publicsuffixlist-0.10.0.20231214.tar.gz"
    sha256 "76a2ed46814f091ea867fb40a6c20c142a437af7aae7ac8eb425ddc464bcb8e1"
  end

  resource "pyleri" do
    url "https://files.pythonhosted.org/packages/0e/94/fa146d2de46b78237562373a2bb9277d69e4149738a11b69c1f42ca64c33/pyleri-1.4.2.tar.gz"
    sha256 "18b92f631567c3c0dc6a9288aa9abc5706a8c1e0bd48d33fea0401eec02f2e63"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "timeout-decorator" do
    url "https://files.pythonhosted.org/packages/80/f8/0802dd14c58b5d3d72bb9caa4315535f58787a1dc50b81bbbcaaa15451be/timeout-decorator-0.5.0.tar.gz"
    sha256 "6a2f2f58db1c5b24a2cc79de6345760377ad8bdc13813f5265f6c3e63d16b3d7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/checkdmarc -v")

    assert_match "\"base_domain\": \"example.com\"", shell_output("#{bin}/checkdmarc example.com")
  end
end
