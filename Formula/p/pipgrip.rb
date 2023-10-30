class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/5c/f9/3523793032c85a569da1c029f05ec89cefc473474b7ea7d3cf06a433558d/pipgrip-0.10.8.tar.gz"
  sha256 "84c7d7023474c6a3fcf08d43f8a28d3b2dc2c9d81a9fe9cbf1247bd40678fe76"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56324ac6bbaaf8bee46f5abcf9f37e7ba11f9945ecd1278c3a112069b76db39c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60eea85cd7d84c757819573be75e2b0277f471e64e73ac6eeffeac684ec46167"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5002709ab2f4aacd9d4696a5a4e17d67afe9fd60cfd96144573bffadb5b6640d"
    sha256 cellar: :any_skip_relocation, sonoma:         "cada845e8cc77e3e5e0d5fb7c39f1f80ad4fd55eee605e6526b2993c86b313b1"
    sha256 cellar: :any_skip_relocation, ventura:        "380319e4c76613a16951bb6be5654f529561529f4f6a23cc3cb01302d138c7cb"
    sha256 cellar: :any_skip_relocation, monterey:       "ef3fb31c8a10580b8cd471a890b11400f44ac44583038913a4572a5d04ff3f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b15fdd980e02e0f64077546f3ffa629f8728a70983fd39d7c545cb912660af2"
  end

  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/7e/84/51e270f1f117da92025427e5cddd71ee62fc65de8b0391568055eb872d3d/anytree-2.12.0.tar.gz"
    sha256 "0dde0365cc8b1f3531e927694f39b903c360eadab2be09c50f3426ecca967949"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a4/99/78c4f3bd50619d772168bec6a0f34379b02c19c9cced0ed833ecd021fd0d/wheel-0.41.2.tar.gz"
    sha256 "0c5ac5ff2afb79ac23ab82bab027a0be7b5dbcf2e54dc50efe4bf507de1f7985"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
