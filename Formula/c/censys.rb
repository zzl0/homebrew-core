class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https://github.com/censys/censys-python"
  url "https://files.pythonhosted.org/packages/64/e2/60e8e2922e64ba38de3948c1ab04cdca6698920bc98d13637f77a259ea08/censys-2.2.11.tar.gz"
  sha256 "d4e161e3085800c0f9b6ff6cc035a7727ff525135cdde62ff01e32eb371c5773"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1118bebaf68587330e4d8df1575c1621978af0e636c0b30c71b3c61c2477ce7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69a215a8692d11a2d58fcff69d5e24f8d06458f25386927a6dc71363f86ba8e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9e03c2a42821f806dd6df299e22784785c468d407fac6ea706104fd4cda5abf"
    sha256 cellar: :any_skip_relocation, sonoma:         "925d667fcfcbeb69b4a286a04b5957839f2f6d8377f0a22baa2dd54c9d21911a"
    sha256 cellar: :any_skip_relocation, ventura:        "e43fd8b675ce381ecf9345f85cb189ef26b751a2fa08f903be618bdb211c3078"
    sha256 cellar: :any_skip_relocation, monterey:       "aed35bf6de8ad81bf42458bca390c616e44bdbcdc102cd9f471f0ff8e90e6704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d14d4226c9df9e595f9489a8cfb100930b3b39b1dd63d5a945a3637cc05561d"
  end

  depends_on "pygments"
  depends_on "python-argcomplete"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: censys", shell_output("#{bin}/censys --help")
    assert_equal "Censys Python Version: #{version}", shell_output("#{bin}/censys --version").strip
    assert_match "Successfully configured credentials", pipe_output("#{bin}/censys asm config", "test\nn\n", 0)
  end
end
