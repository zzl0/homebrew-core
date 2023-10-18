class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.4.2.tar.gz"
  sha256 "f5990b3f63fd085ff0d10af12581f8b37d65c3fdcdc56b9263fff85adaef2d33"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49c88d416620ce980d5fb693ae6b5a6d263a4aaf1d1dc011dc48a50df19207ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68ef463d3e50c597af2772717eff8c0bbce7287f85c1e8d78b8f60287ed24bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b427ea95581a053336be1bf87c872c13d76d929247ba2e9d9d68023dfa774f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3309ebe741a2159d9e33ea2bb316de868b4d46cd949bf68996bdb5f34b22a70"
    sha256 cellar: :any_skip_relocation, ventura:        "a81435f0c9c804070f2280bedf961be7c2738c72ff933c9d0ff83ae20f2d264a"
    sha256 cellar: :any_skip_relocation, monterey:       "48a878f050f3307c810a78ec9dff512442406dd51fa2c014f4878405c12c3017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e44689e35678a6308226a424f60f873db5ca69956884832a3fc050e73f88cc6"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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
