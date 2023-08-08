class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/e8/61/c8a7a82c83b539e830d89b9fb7cc6c20ad241e1526e4ced34643932d40ff/tox-4.7.0.tar.gz"
  sha256 "89120e1568c763924301cfde61ba7d4b5c4615eeb1086d5370deb03e9cf63c41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4abc6f20be8d0c01f78bb8cd5b073e07483bcc42fe7f4b6fe0944382b2bf2a44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef63f7725c296569977366f673b01178dc37f26ae5352441d8f8cfa206c38bfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ac315502d8efa2e89becfd18b55e45659cc11616df1dc7543c08a57f2d6c4e2"
    sha256 cellar: :any_skip_relocation, ventura:        "a80a2be1446c7d82b4a7de388d17269951cedc0be8e21199cbdc0169527a4134"
    sha256 cellar: :any_skip_relocation, monterey:       "0568cd9dcd816180fc1edeb87b29abfcdaab4b9f36b7531b4fc0c57824848751"
    sha256 cellar: :any_skip_relocation, big_sur:        "c74f01b256807f9c31fc5769334fbdae1d33e1aeec90071834a6a41bcc638bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b23607c8f84610c414215d4e0cf3ac02ed0e2ca1088266f9dab18f74b5cf5316"
  end

  depends_on "python@3.11"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/8a/42/8f2833655a29c4e9cb52ee8a2be04ceac61bcff4a680fb338cbd3d1e322d/pluggy-1.2.0.tar.gz"
    sha256 "d12f0c4b579b15f5e054301bb226ee85eeeba08ffec228092f8defbaa3a4c4b3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/f7/70/a63493ea5066b32053f80fdc24fae7c5a2fc65d8f01a1883b30fd850aa84/pyproject_api-1.5.3.tar.gz"
    sha256 "ffb5b2d7cad43f5b2688ab490de7c4d3f6f15e0b819cb588c4b771567c9729eb"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/ea/3a/9e31ffe1d38f2ca7e249445783651548103237b29dd6389c104ff0feef93/virtualenv-20.24.2.tar.gz"
    sha256 "fd8a78f46f6b99a67b7ec5cf73f92357891a7b3a40fd97637c27f854aae3b9e0"
  end

  def install
    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(Formula["python@3.11"].opt_bin/"python3.11").to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_predicate testpath/"src/.tox/py#{pyver}", :exist?
  end
end
