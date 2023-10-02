class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https://github.com/censys/censys-python"
  url "https://files.pythonhosted.org/packages/31/3f/2094e4c07b5f8142242705b8f7af42550f1b70c9ce457684b834850d40ea/censys-2.2.7.tar.gz"
  sha256 "abec858e5be89c45a60477bd7e51412fee7f55917325b11c3cd970298de3e2bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d3a110b8d0680a604069aa2019d01265261912f8370ab388f6a88535091d53e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b56b8b05538dc67440fb82af69f60fbcd28c1358cb335e0f84f9e481c94e4fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dd1022f9d5efa6a55a391947249c9fbb79add49af246f9323e52adf77a462ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ed95fb642d3d19bcbcd3b0e6c5f1b4b1c0a3654b80ac4599fd1e7dc17612987"
    sha256 cellar: :any_skip_relocation, sonoma:         "f39b683f57cf818eb048678ac44d1e9b175b03eea31c0cf60c6f9417ffd12eb7"
    sha256 cellar: :any_skip_relocation, ventura:        "439cfc6fc31aa756ebf337c598f1d9995a197ef45b5fb74ec27b602822fe292b"
    sha256 cellar: :any_skip_relocation, monterey:       "ec44caa4333e6c76dbf51b6ca142816cc6bda902647868182f248dac2459e2fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a40c96b900b8094bfd68a7050dce12d79211e1880c5e9c5ce9f94ee2641adc42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a59f2d92be5d5644e491f1c6632b0535f0ea539ba088d2c2bfa2f1dae38c62ab"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/1b/c5/fb934dda06057e182f8247b2b13a281552cf55ba2b8b4450f6e003d0469f/argcomplete-3.1.2.tar.gz"
    sha256 "d5d1e5efd41435260b8f85673b74ea2e883affcbec9f4230c582689e8e78251b"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/51/13/62cb4a0af89fdf72db4a0ead8026e724c7f3cbf69706d84a4eff439be853/urllib3-2.0.5.tar.gz"
    sha256 "13abf37382ea2ce6fb744d4dad67838eec857c9f4f57009891805e0b5e123594"
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
