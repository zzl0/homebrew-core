class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/5b/ac/b9f4f4df6270d75202583407ddaef8651163127d228758e8418974f70b5a/pipgrip-0.10.10.tar.gz"
  sha256 "b8e947c79eef74100a5dc256a94d377205b3b00816e4195964a73ee28deb9a4d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55addb6f5484988dd0a7ff77b96dd0919db102382e831faf8960d464d202338b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fdf73145e562ddb95ecf2de9a29a23ea96cb10fead10656d57aa4e6aad1aa2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd0dccc7d8836030c0d054c2e7cd7958c8797ee2c2496dd2bd17caba7363d4d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c272e0bd604b2fa9c1e09bf2318ecba8996882919cd70a6e59ab866737bf47e"
    sha256 cellar: :any_skip_relocation, ventura:        "93ed28420b733ea27f307879f5468d9a4612200bf011b6169c5f28c26220bc12"
    sha256 cellar: :any_skip_relocation, monterey:       "13dd37fa4da8b95b0b2f374b91a647b5afd44aee8c8ef2b059bc6c3ad3dc7017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ed675110380eff721572de63fa7be2a4e87e5e26fe9b95d07d5b8fd98e1c01"
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
    url "https://files.pythonhosted.org/packages/fb/d0/0b4c18a0b85c20233b0c3bc33f792aefd7f12a5832b4da77419949ff6fd9/wheel-0.41.3.tar.gz"
    sha256 "4d4987ce51a49370ea65c0bfd2234e8ce80a12780820d9dc462597a6e60d0841"
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
