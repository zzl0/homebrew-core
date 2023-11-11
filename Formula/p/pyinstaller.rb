class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/dd/c8/7bbbb6bb4130f96f7bc32064c13f115546fce07a3aacae75c3b4142256bd/pyinstaller-6.2.0.tar.gz"
  sha256 "1ce77043929bf525be38289d78feecde0fcf15506215eda6500176a8715c5047"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68e3a5161baaffed5e4d86f6ad2edee5d71685d88700f3cf4bdc3b8e9098f6bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "123e17a557831b07d13acbff1bd48a622e0784c548fa7e0254f0b46b2a27e1e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3e36b81c88bf974aa7f0a908065bf041093c370acc5b3a075b6adb47fe71359"
    sha256 cellar: :any_skip_relocation, sonoma:         "862118a27aa224b6cdfd93f6efe06888eaf5f86c6be4212de4c43959db00739e"
    sha256 cellar: :any_skip_relocation, ventura:        "986b4f94c91fdad4c592339bb9c190397d5199076340e1fbe75d440f0df8a139"
    sha256 cellar: :any_skip_relocation, monterey:       "b526c476ad1a3c39a724fd420051530a24dd4b696b03976fc78e9db8de8c2b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948ffc58267af19d3df91a2177ca00de130e20276f821f454c68b8f9ea51b9cf"
  end

  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"

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
      system "python3.12", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
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
