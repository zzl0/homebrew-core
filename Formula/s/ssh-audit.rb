class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/f2/b9/88c7f0ecba0a8fbf07e0d7674b7eac3dbf5270ac39a3b48bc34bb7c5a22c/ssh-audit-3.0.0.tar.gz"
  sha256 "a6a9f94f6f718b56961b70dbf1efcc0e42b3441822e1ea7b0c043fce1f749072"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52cdbe85ff2ae19e72029ac6751cd5553f96ea158f1fee1f9f1f76659aef3e91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52cdbe85ff2ae19e72029ac6751cd5553f96ea158f1fee1f9f1f76659aef3e91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52cdbe85ff2ae19e72029ac6751cd5553f96ea158f1fee1f9f1f76659aef3e91"
    sha256 cellar: :any_skip_relocation, ventura:        "0a10628210e4b2003ae24c7ecac43bbfbedcbc9f99ec51d5ce23fa54a140da27"
    sha256 cellar: :any_skip_relocation, monterey:       "0a10628210e4b2003ae24c7ecac43bbfbedcbc9f99ec51d5ce23fa54a140da27"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a10628210e4b2003ae24c7ecac43bbfbedcbc9f99ec51d5ce23fa54a140da27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62e991c6ee5e1bf92d4e687acaf9d27b941386bc4cb9466db881fc44b45eca4e"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
