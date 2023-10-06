class S4cmd < Formula
  include Language::Python::Virtualenv

  desc "Super S3 command-line tool"
  homepage "https://github.com/bloomreach/s4cmd"
  url "https://files.pythonhosted.org/packages/42/b4/0061f4930958cd790098738659c1c39f8feaf688e698142435eedaa4ae34/s4cmd-2.1.0.tar.gz"
  sha256 "42566058a74d3e1e553351966efaaffa08e4b6ac28a19e72a51be21151ea9534"
  license "Apache-2.0"
  revision 2
  head "https://github.com/bloomreach/s4cmd.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64d6ba679835e76229529b3cf69343facc90aa06e2ccd9294285ae737c582b27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4330aa16ed535e58baec539539457273ca137b7fd940381a5ece53b5ed264377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61b5e9c004791b55d9b448c58823c8e64766b8aae3f98b41d85c9225ea8d3a69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc21a20e8b4e7fc2df9e5f8f4be01ef866cb9c5ea2b59ffbc9912baf8b1a9f0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "34add3299f3dba73217668d597af0b3d82ff7c7d4d90e2c836eb25ff2250ad4d"
    sha256 cellar: :any_skip_relocation, ventura:        "89921083aec7aecee35c209b8f9507a4ca2d7a1b2ea1d8a025c63221f0751700"
    sha256 cellar: :any_skip_relocation, monterey:       "02ba6c7b38706ba52e55eb92017eaab34ae59f9c5ae70742f5aeb6b015a8fb68"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e8c0d2faf3f76e97c7821d4c99b01d2751bc4d55bc9a2fb368b6dd15c2da4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ea903e1a7f0904623d53ed6f1b16dd33affcdd1c8c9a8db55f4b955b050f91"
  end

  depends_on "python-pytz"
  depends_on "python@3.11"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/42/56/633b5f5b930732282e8dfb05c02a3d19394d41f4e60abfe85d26497e8036/boto3-1.28.61.tar.gz"
    sha256 "7a539aaf00eb45aea1ae857ef5d05e67def24fc07af4cb36c202fa45f8f30590"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/2e/9cb8adca433af2bb6240514448b35fa797c881975ea752242294d6e0b79f/botocore-1.31.61.tar.gz"
    sha256 "39b059603f0e92a26599eecc7fe9b141f13eb412c964786ca3a7df5375928c87"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Unable to locate credentials", shell_output("#{bin}/s4cmd ls s3://brew-test 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/s4cmd --version")
  end
end
