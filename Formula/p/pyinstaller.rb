class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/89/85/6c14b541f8e9b61eef5eafba3630d68ea0598f6a4cf531c23189765e9bb5/pyinstaller-6.1.0.tar.gz"
  sha256 "8f3d49c60f3344bf3d4a6d4258bda665dad185ab2b097341d3af2a6387c838ef"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25e9ad835214fc000b8b0a07febfa0017a371eee3a8ff356ca5de0d85f175007"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b683665732bb7b3c7d7bcb6999c393aa5cbf05090584c08f7d7df9990a80ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7979d6856269eab532f78d97b758b1897e0c4522be1739bde3efc14dec1793e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b71f8400b2360e73c16b3f91dd3f386c5e6e1157b3973a19ac87d9a19e9a022"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff3560a83d9d6792d28ddeef0e460feaff601ba9d56ff7b6acdede3b44f8e4dc"
    sha256 cellar: :any_skip_relocation, ventura:        "05f2077e99c517b32a02eaa463ee28b108eeeef2561df82db72bfffa6f37ba47"
    sha256 cellar: :any_skip_relocation, monterey:       "bdd0ebb8d555277b470a50b8f28108b27f6eab38c77890c4598e647864293d17"
    sha256 cellar: :any_skip_relocation, big_sur:        "193b08fed00df9afae277ff2de5676cfa540bf673460ea33e3460d87572cf79c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac0a72a10e361d2c0cfe3cc85601e4ec2a407b8d81c4d18c5ee95beafc020ac"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/de/a8/7145824cf0b9e3c28046520480f207df47e927df83aa9555fb47f8505922/altgraph-0.17.4.tar.gz"
    sha256 "1b5afbb98f6c4dcadb2e2ae6ab9fa994bbb8c1d75f4fa96d340f9437ae454406"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/95/ee/af1a3842bdd5902ce133bd246eb7ffd4375c38642aeb5dc0ae3a0329dfa2/macholib-1.16.3.tar.gz"
    sha256 "07ae9e15e8e4cd9a788013d81f5908b3609aa76f9b1421bae9c4d7606ec86a30"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/3d/e0/d41437880dc87abfc28cb6ae965d113dfd9d7151ef61223b71488062a114/pyinstaller-hooks-contrib-2023.10.tar.gz"
    sha256 "4b4a998036abb713774cb26534ca06b7e6e09e4c628196017a10deb11a48747f"
  end

  def install
    cd "bootloader" do
      system "python3.11", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
