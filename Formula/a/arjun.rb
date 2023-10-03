class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/51/cd/8eaadf3973a4e7bb519b885588b13348ddbe6d97ca06ecdcdda5f7a53dcb/arjun-2.2.1.tar.gz"
  sha256 "b1904add44c0c5a8241910b0555d7e252281187b7dadd16ebc0843dc768cb36e"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c222a6a78644bffa4f4210001ea1370280275068ce4bac69b85c4d1130e5db61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58fb3067a738ec816d57d2749bc304703ad30ce39cc73d97d049e142c4b13d86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a73485dc5b8e940f5a8653b15eb5d3dc02b841199551de73019d4154d4030789"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31f7be78b336f904e935f7e2a5f192b5e5cb6aec331193cb8a6600e6b2525f87"
    sha256 cellar: :any_skip_relocation, sonoma:         "50fa3dfe6d192e985e80f445d380ee17f15580be4573aa1356acd7b392fc8d40"
    sha256 cellar: :any_skip_relocation, ventura:        "92eba3573ef8e3c438186c0045836817fb6ed89ec8eb0a0eaaabec34c5057077"
    sha256 cellar: :any_skip_relocation, monterey:       "7fabbdb2a7a3164bd01ab139ba7ccd4d254efa7e40c2ade599c412de20aee68d"
    sha256 cellar: :any_skip_relocation, big_sur:        "19df3cf79b5734b715ae8a3c0996fdcd748e60f163ac8727956c8bf05a06ac5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f662d9a2aeaa8b36c6ff54a091858051823bb7cbd09ba65ca102c5576a99d0d6"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/ee/c9/3132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5/dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET")
    assert_match "No parameters were discovered", output
  end
end
