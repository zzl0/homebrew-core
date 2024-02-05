class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/74/fd/6c9472e8ed83695abace098d83ba0df4ea48e29e7b2f6c77ced73b9f7dce/vpn-slice-0.16.1.tar.gz"
  sha256 "28d02dd1b41210b270470350f28967320b3a34321d57cc9736f53d6121e9ceaa"
  license "GPL-3.0-or-later"
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3961aeca188dbdb19efb3bd4fb38a981201b5766d93464ba89d41bba7ad83cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b42144d344427daa2c18715bdc7944fdffc663c1034576655cc2edbb98e52949"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7643a624395a9b1ec80cfbb7567be45a3ec860c3864ce596edc97cea3fb7613c"
    sha256 cellar: :any_skip_relocation, sonoma:         "983a3fa1565fa20958bc4ce9b770634467436825dd3f85a01cea3ad443feb32a"
    sha256 cellar: :any_skip_relocation, ventura:        "1c5caf9f3eec5874fa3f42e753399834a7d479b6a72f31075882c2bbfb0b8c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "13339b69283682eb0229bb38d3abcf85f7b024b4c650d433652ac89a1ed201c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1c9ffddb15031d6e821823f58baaf7d855da147d7b1f7f50e7269ecaaeb12c6"
  end

  depends_on "python@3.12"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/51/fbffab4071afa789e515421e5749146beff65b3d371ff30d861e85587306/dnspython-2.5.0.tar.gz"
    sha256 "a0034815a59ba9ae888946be7ccca8f7c157b286f8455b379c692efb51022a15"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  # Drop setuptools dep
  # https://github.com/dlenski/vpn-slice/pull/149
  patch do
    url "https://github.com/dlenski/vpn-slice/commit/5d0c48230854ffed5042192d921d8d97fbe427be.patch?full_index=1"
    sha256 "0ae3a54d14f1be373478820de2c774861dd97f9ae156fef21d27c76cee157951"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    virtualenv_install_with_resources
  end

  test do
    # vpn-slice needs root/sudo credentials
    output = shell_output("#{bin}/vpn-slice 192.168.0.0/24 2>&1", 1)
    assert_match "Cannot read/write /etc/hosts", output
  end
end
