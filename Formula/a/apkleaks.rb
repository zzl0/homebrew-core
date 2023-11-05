class Apkleaks < Formula
  include Language::Python::Virtualenv

  desc "Scanning APK file for URIs, endpoints & secrets"
  homepage "https://github.com/dwisiswant0/apkleaks"
  # upstream pypi artifact issue report, https://github.com/dwisiswant0/apkleaks/issues/79
  url "https://github.com/dwisiswant0/apkleaks/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "c22557f527ee49c04947c1bed1b5ee50857ee68b0f4f3b99a5e4b18dffe30d16"
  license "Apache-2.0"

  depends_on "jadx"
  depends_on "python-click"
  depends_on "python-lxml"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "pyaxmlparser" do
    url "https://files.pythonhosted.org/packages/58/7f/327c19329f535c332451b5f1f906bff5f952fe3070d00376b75e67052f35/pyaxmlparser-0.3.28.tar.gz"
    sha256 "c482826380fd84ce1a6386183861f2a6728017241a230c13d521e3e7737e803e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test.apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    testpath.install resource("homebrew-test.apk")
    output = shell_output("#{bin}/apkleaks -f #{testpath}/redex-test.apk")
    assert_match "Decompiling APK...", output
    assert_match "Scanning against 'com.facebook.redex.test.instr'", output

    assert_match version.to_s, shell_output("#{bin}/apkleaks -h 2>&1")
  end
end
