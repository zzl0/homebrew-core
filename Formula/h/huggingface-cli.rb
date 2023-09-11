class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/f9/0e/b49c3083559fa1fdac927e32ba585e6aa80835bd155bafcfda1136bd4e8d/huggingface_hub-0.17.0.tar.gz"
  sha256 "a048c64e0f651c32afe41a1818bf2cd47de902ff65dfba395ff71b999d9d4655"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cf5612c63cfe4ce49ef44b3c4fe85b7668c1bf22964dd3595502697c11525a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9a9e3acf0568f574e9c914b8e8b8701837eb71bd5f1a479a808069ce771f699"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70a33bca67a583441db61c6369dd90a9f7705838df89b5935286825367d0718b"
    sha256 cellar: :any_skip_relocation, ventura:        "dc456bd58271252d8c0733b767dbceff2702367a6ae504b70d7ea9de50908da3"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc7b6850b3d6fb493f4948bec27cde2aa1d1607784e481cf5acae7f75d35c38"
    sha256 cellar: :any_skip_relocation, big_sur:        "262410f4ab4440be42599e7360daff0ebfedf10c7551126784b496636080cfa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c5184641009b326e8764f109a87c47dfdabc931a5f9babb8d2739e29ee9198"
  end

  depends_on "git-lfs"
  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5a/47/f1f3f5b6da710d5a7178a7f8484d9b86b75ee596fb4fefefb50e8dd2205a/filelock-3.12.3.tar.gz"
    sha256 "0ecc1dd2ec4672a10c8550a8182f1bd0c0a5088470ecd5a125e45f49472fac3d"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/1d/0d/fcbbc5b104a745982118283f07c427a355bf76b8b595005f6b1b9add6b9f/fsspec-2023.9.0.tar.gz"
    sha256 "4dbf0fefee035b7c6d3bbbe6bc99b2f201f40d4dca95b67c2b719be77bcd917f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
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
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
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
