class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.2.0.tar.gz"
  sha256 "0b2b094a515b340f859b417016def33f9b33a47abe4c3fad66c5dbc8b8447a7d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "10d0ce7696abcdacbfbfd919b35a7059abfd466a7888ebbed38c8c87000c4bb2"
    sha256 cellar: :any,                 arm64_monterey: "aa8ad3a6771c1c7c9be369a85ab829f99d491488ba0ecd41092ef2f87604d96e"
    sha256 cellar: :any,                 arm64_big_sur:  "8a4fdb8654924ccae7880d7ae964cc7999ba13ab0e4fe5bf669672b97b8821a0"
    sha256 cellar: :any,                 ventura:        "46747c55b1f890c600569565578f3d820406c44a9c3476e60f450ff0d94c7bfe"
    sha256 cellar: :any,                 monterey:       "917ffac54a32426495e65ec40306fdb8963c15a3cf8aba2d80d62a4ae8727201"
    sha256 cellar: :any,                 big_sur:        "51954e0fc0405ec1dc1fdfe7d57f002424e32b90fe5ff015a4f44be8eac8dfa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a42f7f2b4c0dd68992f0f7f9b1ac9ff93092b5d61e8ecd64d5596c73f97ce5f"
  end

  # `pkg-config` and `rust` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/8e/5d/2bf54672898375d081cb24b30baeb7793568ae5d958ef781349e9635d1c8/cryptography-41.0.3.tar.gz"
    sha256 "6d192741113ef5e30d89dcb5b956ef4e1578f304708701b8b73d38e3e1461f34"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
