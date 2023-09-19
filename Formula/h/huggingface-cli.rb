class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/76/ef/02edc4ffe8f06e118da66279b2fa31e5323d3c82b75d9a5482b67c10f76a/huggingface_hub-0.17.2.tar.gz"
  sha256 "51b0257ff75b422d3cb0662db799c7a03fdc72b8f84a09ce3ff7655dca1958b2"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bd260d7b0b2273a664554225e02d3d3b5998ac41dd1d2ba2de977b335954f8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c41b7e8f48aff7a0a2be2f043419f6afe69168c774ade740f709d3413a4e29b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8618a04f0f6adeada2f65f02937b258d8d47851e155e1ee25078a94b08ef2a3"
    sha256 cellar: :any_skip_relocation, ventura:        "2bd1f94faaecd2f9206591b32a20fcbc34364a3373fc92cecdfb8a4ae683807d"
    sha256 cellar: :any_skip_relocation, monterey:       "d31e0214dc119806431049d1c48b0485fadc4562adef3bee34f52fe1dcb94f6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "401086f78fb755547646c7f82fa88c469c872838d59d0016aadfb1e148cc44c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527b3a774f8dd4fb18abd8a679d56ed50c179008739a396cf72993de6166ea11"
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
    url "https://files.pythonhosted.org/packages/ca/2f/93a4a8eed0234a6b20a32c718ddd0ab712c66b4bda6ce4c3bcd51b279a66/fsspec-2023.9.1.tar.gz"
    sha256 "da8cfe39eeb65aaa69074d5e0e4bbc9b7ef72d69c0587a31cab981eefdb3da13"
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
