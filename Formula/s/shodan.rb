class Shodan < Formula
  include Language::Python::Virtualenv

  desc "Python library and command-line utility for Shodan"
  homepage "https://cli.shodan.io"
  url "https://files.pythonhosted.org/packages/db/14/2e16620742e5d56eb6035c0bbf16ae04a8dee50d67d09d8df4e196d53184/shodan-1.30.0.tar.gz"
  sha256 "c9617c66c47b87d4801e7080b6c769ec9a31da398defe0b047a6794927436453"
  license "MIT"
  revision 1
  head "https://github.com/achillean/shodan-python.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47a6dfa13e9829a83c10e3b906c388116d8a5e46bb1e2083c6536a5611b8a035"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d23152b79f7e15423df02fc752dd27f08f0fec3e56748bd5b7bfb046f171197"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c00759645646e941ae68162fb790ebf0e5218e221676319e54a7ad56f0e7ca87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95219748f36d74a1bacd0a261a11bd342a77f39429451e8d40a8f756ebf10988"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5881f34f6bf047f6afc67a343e41d86d9fda2fac3bddb32c8dac2632430fb61"
    sha256 cellar: :any_skip_relocation, ventura:        "69cf05452061383a55b6acb2af77e1b01c583039b951d53a9c7149795cc29e21"
    sha256 cellar: :any_skip_relocation, monterey:       "fd683642dc5b1b3b1869bb99f8317ff88dd346d77e412fada69d5ad0f1804f1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4b33f527e705e2881bef2c526bc7a8155906a21cb5cb92e8c5cfa1913736907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcced46ba43d54f9c9559b055ba559f0753c4cbacd7eb48d73ff4edf6ebc2da7"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/ba/7a/dc3ffc0e333d33e8ccb63a14adc40180c29d89490a25ebe9f9ef01605c51/tldextract-3.6.0.tar.gz"
    sha256 "a5d8b6583791daca268a7592ebcf764152fa49617983c49916ee9de99b366222"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/e0/ab/bc8d317106c8ea5ff11a2394ae99cb9adf1a9d32c55d3b15eea2b505b875/XlsxWriter-3.1.6.tar.gz"
    sha256 "2087abdaa4a5e981a3ae50b5c21ff1adae59c8fecb6157808585fc169a6bfcd9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shodan version")

    output = shell_output("#{bin}/shodan init 2>&1", 2)
    assert_match "Error: Missing argument '<api key>'.", output
  end
end
