class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://files.pythonhosted.org/packages/96/7b/20bff9839d6679e25d989f94ca4320466ec94f3441972aadaafbad50560f/awslogs-0.14.0.tar.gz"
  sha256 "1b249f87fa2adfae39b9867f3066ac00b9baf401f4783583ab28fcdea338f77e"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/jorgebastida/awslogs.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8c13bf3f6ee08a6ab1e0ffd278857c342dd40ed941c79ce01d8c6aa9ea3b592"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d903b045b2d7f2b6240eefd864cccfe0438c2ad36018d2d61079d9254203575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1efe03135ba5ff520a19fbe02d27510b7c1a04b77052a00994407a2e04ef3553"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb58f1336ed1a9d4c8b393390e00e9ff85f01ec99d6ae561cf6103e2171d6a6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8aa086c0ca98addb3ff42e474ff78f30962789ac0924220f7fe56fe449c3a246"
    sha256 cellar: :any_skip_relocation, ventura:        "050eb23a706b239e08b4ca6e8cbcec2d158351aebfb7e17d771f163dffc9ae16"
    sha256 cellar: :any_skip_relocation, monterey:       "e0546faa28ea19e19406712f90f96e7f4e9a5205383825f0f634106e782b3574"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9c85e3d53f2f3a715cfaa91165b4e722cf57197d09b2fc0341833ba6307221c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "355a36b81ab65751d6c9b9389b7e3e86c2506bae285916fab7ac61bf84b3575c"
  end

  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "zlib"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a8/23/ef75674c1ef3bf77479a5566a1a7c642206298feec1f7012e4710a5b35f4/boto3-1.28.58.tar.gz"
    sha256 "2f18d2dac5d9229e8485b556eb58b7b95fca91bbf002f63bf9c39209f513f6e6"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/77/1d/bd7a7383a2aff3cbf01c758a5507106ac7459707b241d8afbf336520f142/botocore-1.31.58.tar.gz"
    sha256 "002f8bdca8efde50ae7267f342bc1d03a71d76024ce3949e4ffdd1151581c53e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  def install
    inreplace "setup.py", ">=3.5.*", ">=3.5"

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version 2>&1")
  end
end
