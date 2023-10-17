class GandiCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to Gandi.net products using the public API"
  homepage "https://cli.gandi.net/"
  url "https://files.pythonhosted.org/packages/cf/00/ff5acd1c9a0cfbb1a81a9f44ef4a745f31bb413869ae93295f8f5778cc4c/gandi.cli-1.6.tar.gz"
  sha256 "af59bf81a5a434dd3a5bc728a9475d80491ed73ce4343f2c1f479cbba09266c0"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce1f8294b2f45dd75225a93241d94d2bae8bf8adbf4d228dd30e1751797a87f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb16519dc3f206c2af1de48a0b81fca854bca655291f67146940f0e3558f2f00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8df1ad0c5ef9f749b4084c4031f3619964db740f0ad43cad5dafa2b794737b49"
    sha256 cellar: :any_skip_relocation, ventura:        "150df3899afab045028b3463416bbcb3e6802711255e5c7800faa01d7f6aba7b"
    sha256 cellar: :any_skip_relocation, monterey:       "86268b7df7927a754674c7a64db72363bed1b6990e289c3692e7440337e5f5d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bef38c97c708cbb52c3683e5cdd8fdd9f3f96cd8150374f5a81458721e3d0e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94ad4ab88f30cb72e6fee7a8343caa8e8951250724f62785c754c74fdd2335fa"
  end

  # https://github.com/Gandi/gandi.cli#gandi-cli
  deprecate! date: "2022-11-05", because: :deprecated_upstream

  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
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

  resource "ipy" do
    url "https://files.pythonhosted.org/packages/64/a4/9c0d88d95666ff1571d7baec6c5e26abc08051801feb6e6ddf40f6027e22/IPy-1.01.tar.gz"
    sha256 "edeca741dea2d54aca568fa23740288c3fe86c0f3ea700344571e9ef14a7cc1a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/gandi", "--version"
  end
end
