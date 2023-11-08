class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/d5/31/4ae775122014855aa626043bf348a5473fb80ce6492ca57017930eda98d5/huggingface_hub-0.19.0.tar.gz"
  sha256 "7395c9b8053dc8aa0dec2900f367890f66be07bfe46369b95af3f4c1013eb09e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0fe3ff55a9e1f4992fbb41a5e7a76280f677b02a2425d470d8b4777f66d7add"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4af42256e45f1dfb9545145928784b2b95dc8d1020b8088c0d2c988867d8bb16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1409c3ddef5f4b80415b74f816bf059d4e91fcedc8f99025eca884808264185"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cf49acb36530f1da3a4407598544ee09aef73ba50da337331bd1e4091b18532"
    sha256 cellar: :any_skip_relocation, ventura:        "0860c2923a890d8eda2bfdb0c11c8f2500cf791b343cce6355d1e219a7f29c11"
    sha256 cellar: :any_skip_relocation, monterey:       "eeddacd8ec9c58fbbc756070a8f33c57f975fb8cb307a114c38de478ff3402d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14413b4b77eb7a5f2ab44a48e8224f4cc69a12011a0d1a34d3cb4d0b9204dc34"
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
    url "https://files.pythonhosted.org/packages/a4/f7/16ec1f92523165d10301cfa8cb83df0356dbe615d4ca5ed611a16f53e09a/fsspec-2023.10.0.tar.gz"
    sha256 "330c66757591df346ad3091a53bd907e15348c2ba17d63fd54f5c39c4457d2a5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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
