class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https://domainaware.github.io/checkdmarc/"
  url "https://files.pythonhosted.org/packages/3b/e5/45f812e794bb24e5a12c9050fd0ca8386218702ce61ca27fd89a6145b233/checkdmarc-5.2.5.tar.gz"
  sha256 "e219472261fdb6535e844c1259622b6b036720c69ea964c8759da62efa29aa3c"
  license "Apache-2.0"
  head "https://github.com/domainaware/checkdmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e1971a4390acbf96179951bb7e3bc06d3f3a23a341faa2c6b75e789f1164ffb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4581a7551b76b86fa817c660e76c77d873031adf39b81c5fed4986219e5d53e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c226321135a02afe9e3cbcec9251a0ce57042d7d05a9ceea57685a944f02732"
    sha256 cellar: :any_skip_relocation, sonoma:         "e55a14ac99e3f60ba440e413b5149b453da32ef9254a80ed5751be06aae27489"
    sha256 cellar: :any_skip_relocation, ventura:        "34c913dc26c404eb3bf1b45c3ebfc1e5734b33f632acfd702cace22e755d998f"
    sha256 cellar: :any_skip_relocation, monterey:       "03e925897bf4e4eefa161a3751bbf16a76073c097127a2000cbef6ea56e2698f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed2a64f416b31d200e0a0388e93a3e4160638e930dd1c8f3276c92a3c715d597"
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
