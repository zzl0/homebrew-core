class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/8e/9a/64e0e24972057276141403b5971e87d8f51c82ba3d027badc10f39e5524f/parliament-1.6.2.tar.gz"
  sha256 "05f9db2bda8d85f039dbe27716538f025b7cb973d336568762a06217e3b7e3ae"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e01d074f7de71687970fab13562d326b8fcfb432d2dd16a1f57211954179a68a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe1bf228b3700c862f538f5d3b016c1f1d10331445f6660a11db8712b2174241"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faef05880b2eb11adb8d5263786127f3a3ea35e16e69323bfd5fa6575ea5f9c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca7929d4afa4630760e37de691b55b80abdad4b0d3a5fa1c9de358b49d2ca1f9"
    sha256 cellar: :any_skip_relocation, ventura:        "250cd1b0e5fae6451954e44ff7f818bfe3cbf9b52971b0f7fb3ccfa8a1cb56e3"
    sha256 cellar: :any_skip_relocation, monterey:       "45e5d368de43b11dce582538c6a4e21b38fb51a27f9781d5d3ad10da34d6c6f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fe2f41c5140c3829be6e7ed6490d653472b65252da6878f01431df674e7e467"
  end

  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/73/a5/76c27e79a1949a124b48e184bc3fa5b7b8577e1753f0e49ef9675278b0a8/boto3-1.28.68.tar.gz"
    sha256 "cbc76ed54278be8cdc44ce6ee1980296f764fdff72c6bbe668169c07d4ca08f0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/10/98/b46de13cc3dd64e1b9690ff5f60c4497d404d6ad7f6b9c6b2ba849d5b4b5/botocore-1.31.68.tar.gz"
    sha256 "0813f02d00e46051364d9b5d5e697a90e988b336b87e949888c1444a59b8ba59"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "json-cfg" do
    url "https://files.pythonhosted.org/packages/70/d8/34e37fb051be7c3b143bdb3cc5827cb52e60ee1014f4f18a190bb0237759/json-cfg-0.4.2.tar.gz"
    sha256 "d3dd1ab30b16a3bb249b6eb35fcc42198f9656f33127e36a3fadb5e37f50d45b"
  end

  resource "kwonly-args" do
    url "https://files.pythonhosted.org/packages/ee/da/a7ba4f2153a536a895a9d29a222ee0f138d617862f9b982bd4ae33714308/kwonly-args-1.0.10.tar.gz"
    sha256 "59c85e1fa626c0ead5438b64f10b53dda2459e0042ea24258c9dc2115979a598"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}",
    pipe_output("#{bin}/parliament --string '{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}'").strip
  end
end
