class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/77/f9/f6319b17869e66571966060051894d7a6dc77feceb25a9ebb6daee7eed5a/virtualenv-20.24.3.tar.gz"
  sha256 "e5c3b4ce817b0b328af041506a2a299418c98747c4b1e68cb7527e74ced23efc"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f678c2d77ce24f4f44ae96520a55dd64ef0db51edf0e35cd02459dc2dac30d48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65d7bef55b859beff8553879b34a9bb67ad82e88b811664d6cb034b7f28707ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "164edac9b73130839bac1fd2076867e5b0a80c88f3c619d92bd3f6b84a948df4"
    sha256 cellar: :any_skip_relocation, ventura:        "1efa81d03170c7b46d2e476940d494741b3f5e39d25926f502348c4d60b98079"
    sha256 cellar: :any_skip_relocation, monterey:       "2aaca98f447664588878b336d6ddcb9567eeae7ea1ce9a0f53d2c97c0075b291"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f3470ed0c680951df70f28474b8ec1237d4bb381d8d2b1dffc27b4d1d77fd78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "373bf783274db5b7ed31e7c981ad226eff2b0c524c0422cd70a4196e911fb57b"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
