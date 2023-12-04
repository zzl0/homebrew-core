class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.5.1.tar.gz"
  sha256 "17b1268413561b3d1b8564d3d1ed8f025efa34774497df4d54205b6cf0882c28"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aef87af973608dbcce3417d24455da08c7b46b222c8a88aeb16afc9bc28b2d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c8a153478b4e3394a8e7bb88f74e871aec083e4f29fb594a95c8259e521dee5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5ca6820491b5f6c4d9501bc11b6f1ec5d6eec97c8c11d2295f19c0dcdfc6b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "50bcbf901561ad55626122d0a40035f6ee533728ad0bf5f478906c12bed29eb7"
    sha256 cellar: :any_skip_relocation, ventura:        "a31b5ef06bec1ed6d1a3c643ee158da298f74e5b09d5c0e0980f624ab6ab8c09"
    sha256 cellar: :any_skip_relocation, monterey:       "5fdbae99ee6bf1be38fe123a8ac005000198b1a53075b983896bcaea2f461b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50254a3f469e202bc9e1d082ab4851a069b9d9f220e3c345754fa0e9c93bf119"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~EOS
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    EOS

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end
