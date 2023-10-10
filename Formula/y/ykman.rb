class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/e4/25/3a42efa20f10f7bcec116ee678c36fb9a58b8cc12699be9603f1378d6f17/yubikey_manager-5.2.1.tar.gz"
  sha256 "35c5aa83ac474fd2434c33267dc0e33d312b3969b108f885e533463af3fbe4e1"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01ff8fb81759d4bf9ed87555c984c3b2140c14b7356f506dd4c9b34e5fa77659"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f1f6d24841709bcb25424f67cb53f68607c9a00b9a8428f7db074190b23fe50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "688f902225d0dce45af59a13a27fa226020bdd06430c2e1abac4489f6a195f54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55f320e74ba93f8359cf3830d648119914dd2fabee84e881f98215d22f1bd339"
    sha256 cellar: :any_skip_relocation, sonoma:         "df562ffb58ca5bf7c9b2a43a8b6e6970b573ea5fe903dace2b2f8a596be33b2c"
    sha256 cellar: :any_skip_relocation, ventura:        "b0d43e335b614660cbbf1f295130d8fecdda1b226054d516090eb8ded578938b"
    sha256 cellar: :any_skip_relocation, monterey:       "7981e8e3e23954cc7d72733b10c0a50534e0f24a70c272c0c2c4d6b31108b335"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fdeb3fa69775a71f223249f34fc06dccc763d27b754df52e68d22ea065bdb27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e12332ffcd9ae6ff0f93508e782dc4f0b2f3d531848006e25206f54287634582"
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

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/cc/33/b7d115ccf1b594af18db7ca61a7b07192356be35c65dfcd1d5ef9b28dc0a/pyscard-2.0.7.tar.gz"
    sha256 "278054525fa75fbe8b10460d87edcd03a70ad94d688b11345e4739987f85c1bf"
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
