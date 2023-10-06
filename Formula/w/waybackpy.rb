class Waybackpy < Formula
  include Language::Python::Virtualenv

  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cf8ce5b70329254d2ec655017e529b2925e1ccc3668dc03e754e54547277073"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cee3fd02b5fc9ad049d1130db0488a65ad08e13f6b81411dde2609900067ce6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae7d64e2524ddcf10a79ba79a52ce9f01d387103910573453e510fcfed17291c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61293dba2227e814a19a931971360cba689fdd41d8b44d16ef1465d45ae8bedb"
    sha256 cellar: :any_skip_relocation, sonoma:         "295a27b2cf818076ea3fd42a015d3ee27a6d47e8776113c8a195ce59818be0a6"
    sha256 cellar: :any_skip_relocation, ventura:        "70a1154f2875c283a7da59c0ba37abc1d60087bbc15b8e34ba30a4b029c2ebcf"
    sha256 cellar: :any_skip_relocation, monterey:       "8735878f425e79efcaeb853740a3a461df46c5e9c16c1ec59a6f977b9806722f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3abb26084ba0405de912914b10e5b9b1e048a0cfe5fb2c2fbc2605238e912e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5cdcc28a4667af82170728c43d6f8fa0e5816f31ebab66b19174dea9aa49388"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

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
    bin.install_symlink libexec/"bin/waybackpy"
  end

  test do
    output = shell_output("#{bin}/waybackpy -o --url https://brew.sh")
    assert_match "20130328163936", output
  end
end
