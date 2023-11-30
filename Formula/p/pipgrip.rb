class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/1c/c4/e72ccab675d835e3a8632fc145dcb10fc0b3f0f290e958e34c3e126ee6e7/pipgrip-0.10.11.tar.gz"
  sha256 "cb845fd8dcc64c975eb586c18d2fdd7f39a0d10bf7bd0d70b38639eba19d3dc7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a90cca68643dd574d05ac12ad8bab32fe35e44ea2ee7f03b6501980b5b4d948f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0805cdeab867487cb687c41111b47e15bdbe06e22d1165e22fb1095e8658e133"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53f76d2b8261aeaaaedef651933ec837caca270ebe99ec9d8cff6b6f19b0adde"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a68902f3dd106a133650d517656d8e9baee6ba6eb42920b3dccdbbf866b43d5"
    sha256 cellar: :any_skip_relocation, ventura:        "6f3c075ef1cc11c51d009aea52705e242798b5b8bf051b01dcfce3882bdcc5c0"
    sha256 cellar: :any_skip_relocation, monterey:       "6cb489486187db1dfd3b8d2300922abbc26dec786d01a0b5c6eff1a0327a9ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d440684f8a867e112f6f164397cb217b637b822946b4f616091604b63bc9a8"
  end

  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
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
