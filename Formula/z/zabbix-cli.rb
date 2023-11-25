class ZabbixCli < Formula
  desc "CLI tool for interacting with Zabbix monitoring system"
  homepage "https://github.com/unioslo/zabbix-cli/"
  url "https://github.com/unioslo/zabbix-cli/archive/refs/tags/2.3.1.tar.gz"
  sha256 "1d6de0486a5cd6b4fdd53c35810bd14e423ed039ed7ad0865ea08f6082309564"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/unioslo/zabbix-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "642ffe700f81b54022cd4498af1dc1e5d82f8ee7c408b633c438ac1ca3b818dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "703124d0588e3ce655d2a3519a556c39547e8fb72751c6bca9ecb40d71e56cbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "139cba1805f28b7d8667fc78aa5a2647b6cb6b66bfc8c593a21f8bbf55993d4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "14509f5004c729fe5a9e68a683c2cab5172b6f50424dca819e6943dff9f2fbd8"
    sha256 cellar: :any_skip_relocation, ventura:        "c7e1101ab39e7bb2a466aa21fdff21dacaf81a2ed6353dee127d64d5a5ecb6d9"
    sha256 cellar: :any_skip_relocation, monterey:       "34d01b3935aeba3bcd27d3754b1f848bfef4dfc920e083b090aa079094fc757d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e755c98bf015c689e0b3b2b88e077cd37cf225d6c91f89b9fafd0782e950100"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    # script tries to install config into /usr/local/bin (macOS) or /usr/share (Linux)
    inreplace %w[setup.py etc/zabbix-cli.conf zabbix_cli/config.py], %r{(["' ])/usr/share/}, "\\1#{share}/"
    inreplace "setup.py", "/usr/local/bin", share

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"zabbix-cli-init", "-z", "https://homebrew-test.example.com/"
    config = testpath/".zabbix-cli/zabbix-cli.conf"
    assert_predicate config, :exist?
    assert_match "homebrew-test.example.com", config.read
  end
end
