class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/13/d2/e0d36491422425bb882e4a6432a06aee9e56348aeefd9aab648a995d173b/huggingface_hub-0.17.3.tar.gz"
  sha256 "40439632b211311f788964602bf8b0d9d6b7a2314fba4e8d67b2ce3ecea0e3fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e8c47fe829716ff50b6816fb6bbf5fc899a1b72643567f1c9a28c8d233250f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4640b94bf7493f94c34ae39f933ea2eb845eb7d7001e2b8f4d229f7ae7dc949f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89d6cc844ef5204bacc35865bce661adca5a97471d371f96ccd405b75252dbdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bb3056e606775d287bca61e8be99b44828e4abe65694f9b03e1eefbe5a80045"
    sha256 cellar: :any_skip_relocation, sonoma:         "7db8d2a63c5b022f010de86880b65cd94530c230e1e187737e7ff8b51cc7caf4"
    sha256 cellar: :any_skip_relocation, ventura:        "190142660aa78ff38118ee036d2fdd234a67e0abdf9d39f841b1db63236b897b"
    sha256 cellar: :any_skip_relocation, monterey:       "982cb7c59dcc9e89e6aa1ac0cd1660ea540d24e7a7ec8367aa7404bb6abef4e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bed53e30c81e04ddc6955de18bae519a4e64e2acf331792f53702a749c075fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a15a8871f164133710eb7e5aa04350dae44b66bf9fc587ca6d2c17ae0874128d"
  end

  depends_on "git-lfs"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/bd/c1/b9dbe600903f9ac2401e42f38cb376130485a6d0db611f60ab05fa8d21fc/fsspec-2023.9.2.tar.gz"
    sha256 "80bfb8c70cc27b2178cc62a935ecf242fc6e8c3fb801f9c571fc01b1e715ba7d"
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
    url "https://files.pythonhosted.org/packages/51/13/62cb4a0af89fdf72db4a0ead8026e724c7f3cbf69706d84a4eff439be853/urllib3-2.0.5.tar.gz"
    sha256 "13abf37382ea2ce6fb744d4dad67838eec857c9f4f57009891805e0b5e123594"
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
