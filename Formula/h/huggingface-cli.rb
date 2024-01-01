class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/63/f8/820eb08c72c3bf7cfaffbff6631cc78818824c8dae4fc36667796065325e/huggingface_hub-0.20.1.tar.gz"
  sha256 "8c88c4c3c8853e22f2dfb4d84c3d493f4e1af52fb3856a90e1eeddcf191ddbb1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed522bda88120de25ae444fce5a8264d8cd3da9c06014355bbd040cb5fc22087"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "013bc83de7ec5de499526b120158feab113b82e67da01e2add19da1b23e0b35b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b52dfa6a14a27a40b0a8c5816edd8ba028cd66124696e236e6c20f44ce8a079"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe06c36e06c355dfc87f345e0ea92b75c39428b5a8a294e1eb0638dca8a909b7"
    sha256 cellar: :any_skip_relocation, ventura:        "545439425298c2b4c78b7ebc1991b6979fce26652b6a1a44db83903e9340b04c"
    sha256 cellar: :any_skip_relocation, monterey:       "d3b6444e4d86ef7ba698893fe03ce8aafa8a7623edf98e0b75da6c158fcdc776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "435745aea8fa54bc47fac152cda9ab3773d461b058696002f5dd62f56d46a233"
  end

  depends_on "git-lfs"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/fa/08/cac914ff6ff46c4500fc4323a939dbe7a0f528cca04e7fd3e859611dea41/fsspec-2023.12.2.tar.gz"
    sha256 "8548d39e8810b59c38014934f6b31e57f40c1b20f911f4cc2b85389c7e9bf0cb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    whoami_output = shell_output("#{bin}/huggingface-cli whoami")
    assert_match "Not logged in", whoami_output
    test_cache = testpath/"cache"
    test_cache.mkdir
    ENV["HUGGINGFACE_HUB_CACHE"] = test_cache.to_s
    ENV["NO_COLOR"] = "1"
    scan_output = shell_output("#{bin}/huggingface-cli scan-cache")
    assert_match "Done in 0.0s. Scanned 0 repo(s) for a total of 0.0.", scan_output
  end
end
