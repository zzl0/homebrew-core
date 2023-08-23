class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/51/e1/84b207ea1ac7140a626988f6cb46e1ad30c46996715ab8940fbc079461ba/pspdfutils-3.1.1.tar.gz"
  sha256 "86f9c769b6b1a76ddda64fe0d28694545de0397aafa318dc2cae809037569018"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7ed1ffebd53f3afe961aa3acddbb2070127f933b32ee9e69bbc915a629cb7af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eb4ffc9c07f0c0af735ef7ff00e3593f2ca5e68d15c4557ccb498a253112444"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dddc0ac2f721f31f7210d5c5c6b442000763e015e1ae04b5eeadb33211ab2c57"
    sha256 cellar: :any_skip_relocation, ventura:        "ec58679192503bf7e2f30c4aa8f868deb9d119a0ce2fb6ac9370f0ae17738447"
    sha256 cellar: :any_skip_relocation, monterey:       "87ec1ec2444d1fe25d4c7fd9cf892c039629d39d0681a08983d6abf8fee190f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c3872d8ccb721fc3530340609e21a857665d276971cb2406dde3b27fd7eaa5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "054653a32f042fd3f9f5391955bf40d966919097a9af11f412b62a7117997356"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/9f/0d/159af7af2a0a14a3b890b0d0e19db267c07888cb0f569c818b30607b9ed7/pypdf-3.15.2.tar.gz"
    sha256 "cdf7d75ebb8901f3352cf9488c5f662c6de9c52e432c429d15cada67ba372fce"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test-ps" do
      url "https://raw.githubusercontent.com/rrthomas/psutils/e00061c21e114d80fbd5073a4509164f3799cc24/tests/test-files/psbook/3/expected.ps"
      sha256 "bf3f1b708c3e6a70d0f28af55b3b511d2528b98c2a1537674439565cecf0aed6"
    end
    resource("homebrew-test-ps").stage testpath

    expected_psbook_output = "[4] [1] [2] [3] \nWrote 4 pages\n"
    assert_equal expected_psbook_output, shell_output("#{bin}/psbook expected.ps book.ps 2>&1")

    expected_psnup_output = "[1,2] [3,4] \nWrote 2 pages\n"
    assert_equal expected_psnup_output, shell_output("#{bin}/psnup -2 expected.ps nup.ps 2>&1")

    expected_psselect_output = "[1] \nWrote 1 pages\n"
    assert_equal expected_psselect_output, shell_output("#{bin}/psselect -p1 expected.ps test2.ps 2>&1")
  end
end
