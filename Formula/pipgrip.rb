class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/d9/f4/4f9efdc49097bcec4bc138ea0d55fff1db6ad54b032441ec4c0a78fc8982/pipgrip-0.10.5.tar.gz"
  sha256 "dba22c035439ee7942ff2989c33de7ce5247519dcef81bd9dd5042d3b35db3d3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c18cb820ee0e1bc055151788d53615de04d92906cfa797fd1f7ae0845bd37bc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4355b59405f1da21ae2e551cb93be0cac817d110ac351d1de15cd2d494a7490c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6aae463dd8bb2149655b22555385a4130de5ccd91d73fa4513b3d6b8d856befb"
    sha256 cellar: :any_skip_relocation, ventura:        "13d25363d7a764ee74e3f4b065bb5f22031acde890a96ceedc5b4d40c495cec7"
    sha256 cellar: :any_skip_relocation, monterey:       "f979a0ef7ad5ac34d753eea71cedc1c91470793afe243eca1a2915df07f316f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "755f6718559d08e0e346542743dfcae15f3e3af7ec18c637780706e3073cf7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b788320b39cf5db887f51d994170a33fe4c19431bb914a5f327b5a6ad83a3c9"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/ed/20/560b2c0801762f3de73ce04dd20d50ec39c2cdae83f23b6ed81cc72c7558/anytree-2.9.0.tar.gz"
    sha256 "06f7bc294293da2755f4699cc5da5c92d9182a5cfae2842c83fb56f02bd427c8"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/23/3f/f2251c754073cda0f00043a707cba7db103654722a9afed965240a0b2b43/pkginfo-1.7.1.tar.gz"
    sha256 "e7432f81d08adec7297633191bbf0bd47faf13cd8724c3a13250e51d542635bd"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c9/3d/02a14af2b413d7abf856083f327744d286f4468365cddace393a43d9d540/wheel-0.41.1.tar.gz"
    sha256 "12b911f083e876e10c595779709f8a88a59f45aacc646492a67fe9ef796c1b47"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
