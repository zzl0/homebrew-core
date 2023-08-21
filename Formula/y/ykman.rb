class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/f4/69/6f67728862a97903f060df2e687aa836ab48e453cd47da316ff4411d5cf4/yubikey_manager-5.2.0.tar.gz"
  sha256 "45e0f09e3cee2375b6f930dd5d89c1d3a7ca5d5cccb599b16a12f8f7d989fd36"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02472f99430c2acf79707fc6daf08b5fbba173f6e49272f9720be65a646b4277"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "932871713f6120ead63242e92bb5161c6970e9653e2474f1bb3ec727d9238a76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32aaf52b2f1eb2470ae08a03238fdbc81e5e74ff3fe183f30f3f5dca54153943"
    sha256 cellar: :any_skip_relocation, ventura:        "6c415f4a15e876176bdf54c2dc58c6b304854f17ea478e4289f22820db0daf12"
    sha256 cellar: :any_skip_relocation, monterey:       "1257daac542e2fdfda45584f9cc6052db16a53f34739a9996841134746ff201d"
    sha256 cellar: :any_skip_relocation, big_sur:        "25f7a78b74870c6b1160605179eebe193a82b769f902b864fb2880fe0f1433aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c675b26e1d23eefed38c3c7516029024028ef1aec832b0269c7ce3d9c8c0aa4"
  end

  depends_on "swig" => :build
  depends_on "cffi"
  depends_on "keyring"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  uses_from_macos "libffi"
  uses_from_macos "pcsc-lite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/a7/0f/b9f940372e0baa5a44742012f1eef1563296569db030a422ef3ce287b0ac/fido2-1.1.2.tar.gz"
    sha256 "6110d913106f76199201b32d262b2857562cc46ba1d0b9c51fbce30dc936c573"
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

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/cc/33/b7d115ccf1b594af18db7ca61a7b07192356be35c65dfcd1d5ef9b28dc0a/pyscard-2.0.7.tar.gz"
    sha256 "278054525fa75fbe8b10460d87edcd03a70ad94d688b11345e4739987f85c1bf"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e2/45/f3b987ad5bf9e08095c1ebe6352238be36f25dd106fde424a160061dce6d/zipp-3.16.2.tar.gz"
    sha256 "ebc15946aa78bd63458992fc81ec3b6f7b1e92d51c35e6de1c3804e73b799147"
  end

  def install
    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC" if OS.linux?

    # Fix `ModuleNotFoundError` issue with `keyring``
    site_packages = Language::Python.site_packages("python3.11")
    keyring_site_packages = Formula["keyring"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", keyring_site_packages

    virtualenv_install_with_resources
    man1.install "man/ykman.1"

    (libexec/site_packages/"homebrew-keyring.pth").write keyring_site_packages

    # Click doesn't support generating completions for Bash versions older than 4.4
    generate_completions_from_executable(bin/"ykman", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
