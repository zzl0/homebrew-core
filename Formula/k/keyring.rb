class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/69/cd/889c6569a7e5e9524bc1e423fd2badd967c4a5dcd670c04c2eff92a9d397/keyring-24.3.0.tar.gz"
  sha256 "e730ecffd309658a08ee82535a3b5ec4b4c8669a9be11efb66249d8e0aeb9a25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfb207b6f641c2ff7961319af501360fd9ee77247ca443bc29e31f896f6e4cfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b527b69ed89f91958d64a6dd2b2b04eb520a89941b43f6d420d7e740fb89bc9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4513434e3f247a7106767ff10e5682495ee45af8644e5c0c644dad52f8a9c39"
    sha256 cellar: :any_skip_relocation, sonoma:         "dded1608eb74f126ec6b78a26ab6b01818af3fc2842721efe34c15442a78a1d2"
    sha256 cellar: :any_skip_relocation, ventura:        "051d8b236aeefb5a2e0be6a2184b2937a30353b673e57ad0905a60b43e99ec2e"
    sha256 cellar: :any_skip_relocation, monterey:       "f15be5fcfb67ae863aa19f7adc2548e0b186cd7df4a44ad502ea7719db91b6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "861e579bbfb8fc83eb38ee6c1685abd366e67ae65e5ceed7fe6f4b8226a82a00"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python@3.12"

  on_linux do
    depends_on "python-cryptography"

    resource "jeepney" do
      url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end

    resource "secretstorage" do
      url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/8b/de/d0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfa/jaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2d/73/3557e45746fcaded71125c0a1c0f87616e8258c78391f0c365bf97bbfc99/more-itertools-10.1.0.tar.gz"
    sha256 "626c369fa0eb37bac0291bce8259b332fd59ac792fa5497b59837309cd5b114a"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/72/5c/6614a030e5308c244f3fb7ada978d3860720d8dc69522c651d3052c50e8c/shtab-1.6.4.tar.gz"
    sha256 "aba9e049bed54ffdb650cb2e02657282d8c0148024b0f500277052df124d47de"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"keyring", "--print-completion", shells: [:bash, :zsh])
  end

  test do
    assert_empty shell_output("#{bin}/keyring get https://example.com HomebrewTest2", 1)
  end
end
