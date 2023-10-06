class Watson < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to track (your) time"
  homepage "https://tailordev.github.io/Watson/"
  url "https://files.pythonhosted.org/packages/a9/61/868892a19ad9f7e74f9821c259702c3630138ece45bab271e876b24bb381/td-watson-2.1.0.tar.gz"
  sha256 "204384dc04653e0dbe8f833243bb833beda3d79b387fe173bfd33faecdd087c8"
  license "MIT"
  revision 2
  head "https://github.com/TailorDev/Watson.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6fea2dfd7ad274a7f05761909c2c981d771ac14d4ec7c04ebac641fe35000b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a49bb663f5754f6c48efaa796e52da88947ee4859a3431f7dc0ddfc342225b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebc300c1bea8d6c1fa24023ee0b03b20d4e96cd202ad6655df1777997b4c3dac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82529e1e4ab72e0afb728aeb860aace2c6c8cf141aa694a2bd937fb8ff62894f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a883f0035dd0efe8300ffa2cf899259898a2900e3ad4daa5433bbac763bd1404"
    sha256 cellar: :any_skip_relocation, ventura:        "6299cb9603b6d92df078dcad6335d9e0a2c0f168152f943f33c18fa8ab78d160"
    sha256 cellar: :any_skip_relocation, monterey:       "75c274f6c607e113dfbca8ec5c1233ea7998078f6dff734951caa51247a62147"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd88430fdf3a321c7c8b689ae07970592fc2d7a4920357b29345afc451a1bc42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bcaea26d29b856fcabe61586a819c6e0e7570e4fbc0eb7be46e73d6eecd211a"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/2f/a7/822fbc659be70dcb75a91fb91fec718b653326697d0e9907f4f90114b34f/click-didyoumean-0.3.0.tar.gz"
    sha256 "f184f0d851d96b6d29297354ed981b7dd71df7ff500d82fa6d11f0856bee8035"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "watson.completion" => "watson"
    zsh_completion.install "watson.zsh-completion" => "_watson"
  end

  test do
    system "#{bin}/watson", "start", "foo", "+bar"
    system "#{bin}/watson", "status"
    system "#{bin}/watson", "stop"
    system "#{bin}/watson", "log"
  end
end
