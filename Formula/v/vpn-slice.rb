class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/74/fd/6c9472e8ed83695abace098d83ba0df4ea48e29e7b2f6c77ced73b9f7dce/vpn-slice-0.16.1.tar.gz"
  sha256 "28d02dd1b41210b270470350f28967320b3a34321d57cc9736f53d6121e9ceaa"
  license "GPL-3.0-or-later"
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f896ac80b3ec9f781a35eb528bd7ca529dd7c50327f8c9cf3306a9779087d49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7798a26686d124c506967ff63713b888fc36cadbee332330a5260ea925837b28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03c28ff89eec7cc5e56ef7daf5ac634527b5cdc5c7203fa2a55aad4c13eeef05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "891ccb3aa60a9a987136f616f5037c1cb8b58835042b96f7d71bc66b29ae9c38"
    sha256 cellar: :any_skip_relocation, sonoma:         "a240caf21265031f4018364c61375bc9f5b22db8e4f456acd401d861827f5728"
    sha256 cellar: :any_skip_relocation, ventura:        "ad37647e9afbd689a2dbba1beabe018dc5c4cd26476d2dab30fbbd60554bf9da"
    sha256 cellar: :any_skip_relocation, monterey:       "0fed89c47a9cd556d276233a55b54d7ef21ac683e7d8054827f51bf3adb699ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "63f4dec62b148f81d1de93cd938363ef9f51f542974f172b3ada0e317c391875"
    sha256 cellar: :any_skip_relocation, catalina:       "37659888aa845fa2726e77c5973109b9b2552d4bea491f3b84e3d7c1d6eaa9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e0387688208ea25eb4f1a3ebbe358ebb9b00d530714c1dcd6b01b4152493a8"
  end

  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # vpn-slice needs root/sudo credentials
    output = `#{bin}/vpn-slice 192.168.0.0/24 2>&1`
    assert_match "Cannot read/write /etc/hosts", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end
