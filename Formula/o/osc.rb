class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.4.0.tar.gz"
  sha256 "bc083473d5677ba75e2b9adf867c32fc17bb11adc38d863cf9c7a2d8c1d01287"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "269709d25fffe18a00c3c79d85cb0256053fb484d8f201c1b14a0ff0813069a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba87f53d181c1feb7e4d7a8503c9ef6b0e248d5c3659d72d865547e8a5dfdcb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "444e7a6b88fd425d0af40acbd57a304f079ebeabdd650b97c11f8a8c04bce8dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4552d489269cdb724a5ee65ab916c4a41f0a3a4baf50fcd9d65d5f44a41749c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4749b99baa9d2a6030cf8130a2391cd9b763d8d6ec912d89eb7cb40db6c7e34"
    sha256 cellar: :any_skip_relocation, ventura:        "a8bf22d523c081adbf36e0e8a9b8ac0349ea6af0bf1c9515a2ee2c0ccf7fdcb8"
    sha256 cellar: :any_skip_relocation, monterey:       "34b219fca71847b18fec439feabe73a686df04f3c7e91c184fde2f873dcd8093"
    sha256 cellar: :any_skip_relocation, big_sur:        "377b241e75fc821c90df9fa35255361eff998770dc42e7412d788e075d910f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "352bf366e1130d660d2cfbafe91e56c1b8dfc530401e4c6a37a09ba1bb98a65c"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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
