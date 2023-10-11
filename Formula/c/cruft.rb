class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/d8/59/bb9e052fba37972e4b27db74d0bc770bade501d48336dec3c89fe57e9513/cruft-2.15.0.tar.gz"
  sha256 "9802af66037418655e7e4b6f30b531591e0761939b3ff5dd45d27c3a3f588abe"
  license "MIT"
  revision 4
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6892a43c948000120534f59b16527d28d482a56fa4aea5019e02000904e6ea93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db9965b04a41d22b832d7577d603addcec08020f67bd1e7d70306b08557d2b79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e56fa8b73b043e22323305817df1c7d4fcad18b985f80a8fd8e3b6eca47e1093"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82331c9593ab52350c1e734ee93814679bcd892509782ccd0c60f2527979fc91"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8977cbd9b2c237a5b289985904cc11e8a0aa5e10adcd9a3cbb883f9d9fc4dd6"
    sha256 cellar: :any_skip_relocation, ventura:        "b1a02c457851993c9f9a44815a3ed6998f5ee75eb2238f5e34ba265c5b601898"
    sha256 cellar: :any_skip_relocation, monterey:       "4f3e1d55220c514654bdab569c09da751e16b3acce2ffa1e9867c1f2ea4db293"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d866955076136994bbb5cb667998d34b46bd849281f2f91950f870cacd03c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8d006f394191b34543c5a1b502cabc95c08f8fe928fee5079c9615818cca436"
  end

  depends_on "cookiecutter"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c6/33/5e633d3a8b3dbec3696415960ed30f6718ed04ef423ce0fbc6512a92fa9a/GitPython-3.1.37.tar.gz"
    sha256 "f9b9ddc0761c125d5780eab2d64be4873fc6817c2899cbcb34b02344bdc7bc54"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/5b/49/39f10d0f75886439ab3dac889f14f8ad511982a754e382c9b6ca895b29e9/typer-0.9.0.tar.gz"
    sha256 "50922fd79aea2f4751a8e0408ff10d2662bd0c8bbfa84755a699f3bada2978b2"
  end

  def install
    virtualenv_install_with_resources

    # we depend on cookiecutter, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    cookiecutter = Formula["cookiecutter"].opt_libexec
    (libexec/site_packages/"homebrew-cookiecutter.pth").write cookiecutter/site_packages
  end

  test do
    system bin/"cruft", "create", "--no-input", "https://github.com/audreyr/cookiecutter-pypackage.git"
    assert (testpath/"python_boilerplate").directory?
    assert_predicate testpath/"python_boilerplate/.cruft.json", :exist?
  end
end
