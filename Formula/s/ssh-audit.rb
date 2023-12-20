class SshAudit < Formula
  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/c8/b9/974b5dff0b2ae42fde4773f3115e02aa58efed93b70a4888888c056238f8/ssh-audit-3.1.0.tar.gz"
  sha256 "c1c0e9e7352140e4d36aea6b447210e9e0fc00314b823d3ff96352d558bef677"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5229302356d2e1839acdd9174bffbad77271c646048022051f1ea00cdfd1d0e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60f0fc9f4e0fe22be6fe39d74f5e3a2a38babefc61f0724ddfd479ef34946388"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82575a183e2c6067111ae777d39e9c43ab5b6891ac3f173cab0ad5742e4e3f6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "31ce6a625bc07187447328e5cbd24ad9dd81bd017ed96ac724ef2d854911194f"
    sha256 cellar: :any_skip_relocation, ventura:        "95f583606745e4404dfcf4bafff08705cde48f19ec56bea2c22eba9d6dd06555"
    sha256 cellar: :any_skip_relocation, monterey:       "0408b1b95477a41cb770d221acaa2cbd84e03a1dfb4258d0ccbf01e31dfd8fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bc257c84d6d246e6e3c9302dfeaa23561867f9dc9a439378858fd400f3174f2"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
    assert_match "[exception] cannot connect to ssh.github.com port 22", output

    assert_match "ssh-audit v#{version}", shell_output("#{bin}/ssh-audit -h")
  end
end
