class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/0d/01/d29f952e15bbcad0b2fcaa2194aefa95d3cdb2179ad504bacef82d4920f4/terraform-local-0.17.1.tar.gz"
  sha256 "88d1c150a9fa0b6d9876caebc4bd0b4ed3301410e552a566a97fc7770f65b0df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7b2db4d52a38ad39e322e1b7bceb62dce4f92d41856c97833c8cb31f189ddb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa108ef5ebc42c2061e48a07048265beffa3f76d90b9b3a3750f4add34e65752"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ddc7d9c22ee0aa143ea026a86b8da2709509b7b1e46ffdb67065cd38946b2cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "70da163302d60c9bd89ca14af1d0b46845e4c97c47dce3f12d7280bcd59bd3c6"
    sha256 cellar: :any_skip_relocation, ventura:        "e426a74f619051ebc50304d090c52b59cbeba0806473e801c8aff732b88f6809"
    sha256 cellar: :any_skip_relocation, monterey:       "001f2fa251019745bb5fcfef39da584785c20b69099dc64f20577d223e509d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3c41d5cba4b2db64ed71a4835657fd6173a5a84603a183abb2406fdb8129df"
  end

  depends_on "localstack"
  depends_on "python-dateutil"
  depends_on "python@3.12"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e8/5d/26033982549009a54cc09e636fc3eb7d46f09c8fe093e15e39766a6b48ae/boto3-1.34.33.tar.gz"
    sha256 "5bbd73711f7664c6e8b80981ff247ba8dd2a8c5aa0bf619c5466cb9c24b9f279"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f5/53/998e633235bf914b60c320987f612191d52a81fc3af67ce602fe2afd3ece/botocore-1.34.33.tar.gz"
    sha256 "a50fb5e0c1ddf17d28dc8d0d2c33242b78009fb7f28e390cadcdc310908492b0"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/2c/e1/804b6196b3fbdd0f8ba785fc62837b034782a891d6f663eea2f30ca23cfa/lark-1.1.9.tar.gz"
    sha256 "15fa5236490824c2c4aba0e22d2d6d823575dcaf4cdd1848e34b6ad836240fba"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/ce/f6/7c19f1249cdcdc946616387e8aa93472f879624eb6acdd31a78a76fc046f/localstack-client-2.5.tar.gz"
    sha256 "8b8b2ee6013265a55d3e312a4513efccd222131bed79395545a4f643704f9213"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/ef/94/cc6f7100a857a5a4a676c2c71322ca476051278fad4ec956f0116c1d3834/python-hcl2-4.3.2.tar.gz"
    sha256 "7122661438be27ccd8b8f3db71969d8ef2cce3b3cf183e88f8172575e7405a65"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end
