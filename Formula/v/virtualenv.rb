class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/ac/fe/028d5b32d0a54fe3ecac1c170966757f185f84b81e06af98c820a546c691/virtualenv-20.24.7.tar.gz"
  sha256 "69050ffb42419c91f6c1284a7b24e0475d793447e35929b488bf6a0aade39353"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a4529508e929dd748d76e6a2e49201a4773291c0ceced429fa357559ff73e9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7b1bdef632cf9dc558cc549237112c58a457b6cbb00538c0f3323d915a2dfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9019c67e47a10857affbad2511619474170f2a2e159210dfbdbf3dbc035cc346"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ebb11e7fc232820c19ab4f84f322a94bfe22d169cc54d0f64af474d4eba8f07"
    sha256 cellar: :any_skip_relocation, ventura:        "9b64eff381406c5121c383a9d67575368f0d62c057e29a55f54902267a9f1b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "56fea4a6b8f1428dd150fdfbc385e622e242c7d8de806d6c479ff0e1227246d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "799e0f7f9e08a2013092e42164d17c53a200ccc354dba803bb85b3ab74ce20b9"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/31/28/e40d24d2e2eb23135f8533ad33d582359c7825623b1e022f9d460def7c05/platformdirs-4.0.0.tar.gz"
    sha256 "cb633b2bcf10c51af60beb0ab06d2f1d69064b43abf4c185ca6b28865f3f9731"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
