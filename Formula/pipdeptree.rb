class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/6d/b4/42f9f41df0a00084904778cd52b0d400ee34317f67b071f68df48dec62d5/pipdeptree-2.13.0.tar.gz"
  sha256 "ff71a48abd0b1ab810c23734b47de6ebd93270857d6665e21ed5ef6136fcba6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dc4a125b4345a7e74f88f77279380ef1d58f2bd3d3b829b3134605fbb8cf4c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9648ea612e56f44d42e1a9c83471b3c80d2fed0f449fe583b2f5e02ee245a2f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "362a82d9554f33e2f9591b5eb5c347104b37db17769df70f78a066cccd3fc4cd"
    sha256 cellar: :any_skip_relocation, ventura:        "1d9371589bce16ba0b2bdeee5f3870b4e626439b505c09ecbcfbefe7565a7977"
    sha256 cellar: :any_skip_relocation, monterey:       "c7c4818c0becac2a65217120f816f4a4924858c69209d5bf4fd3bc51fd152b79"
    sha256 cellar: :any_skip_relocation, big_sur:        "e26c876cfab9dbf5b78de11b5327a5d758b7a19c289dbc95014479876c6b36eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f627f35269bd339301a7745c3c50b8262807ebd7e0680f33c7e2da26521993dc"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
