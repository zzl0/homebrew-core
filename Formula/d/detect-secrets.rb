class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  revision 2
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c52a490e637286e1f8085413c0aa2391c731725fedd05b811d23c87b5ebd9ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7d406f96b55d25c172002af752f055d8b16cb941c1c8f71b1f109c34f01618f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a360bf8ffe9ddf0fc025431061a6f155dfb65e2f59febc53f55316ede82eb801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f631142f552c0d1a03258b135963a753cbff2297602384142b2f8cc886deec5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "18973a0ac282869bdf63b5f7f8dc740d9f07bab936576765404b5062408fb62a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f51a6d84d1c69b8121340b12648e71c900a8c073f027caac8e4eba0e7935792"
    sha256 cellar: :any_skip_relocation, monterey:       "1dabc85eca7b07da8551ffd5951ddeffe52c20772e626e184fe5273c411984c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3165fd88b2217ed08c8cb860ab03f9f45c84c8b756867a2f83f0c8f9d8c6b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a0f337444e9930d38bc5e8df2eb26fbe3c9f8952c842f153cdbce5aab55adc"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
