class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  url "https://files.pythonhosted.org/packages/d7/08/264d5c0b1a2618c95f3a391e038830c18bcccce5f202b293acdb14b7ac63/awsume-4.5.4.tar.gz"
  sha256 "4c1f6336e1f9e36b2144761345967f50f43128363892cc62325577201e133b1b"
  license "MIT"
  head "https://github.com/trek10inc/awsume.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a81ac39e8c197e5ed36534cfc23f573e40775aa824f0bd450f8e381441cf95ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "300eeaf0ad9e1ca207ee6d464d9c0b640a45f93fd32257909d98c2f87d599407"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fb70bd9e57d6b27c746c731b60ce4dcc6639ddf253d5fb615f4c74e58c1d315"
    sha256 cellar: :any_skip_relocation, sonoma:         "939613eb6cb25804176e03e4c4e169c55d9f8f1beeba6fb5bc082df7c9446a63"
    sha256 cellar: :any_skip_relocation, ventura:        "e2784202d8aad654b710cd1b3e4e2641bb1afe218d064c4939f92037fda7e080"
    sha256 cellar: :any_skip_relocation, monterey:       "a3025b59faeaae4254f48523e8c3fb436b2013fd6d1192f606020cefe2e94f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d20e0464b529558106606be9e9460c4adfeade68f7d0a5464c2a9ebaad7fe915"
  end

  depends_on "python-psutil"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "sqlite"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/5f/b6/1e45c3a145304c3feaf48959c6a46efe9a256eec4d417a445b0d9827d20c/boto3-1.34.14.tar.gz"
    sha256 "5c1bb487c68120aae236354d81b8a1a55d0aa3395d30748a01825ef90891921e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/35/6d/a5aaf38f980060d17905398301033e9eb45c2552bf281fa7fd4c8e23ebdd/botocore-1.34.14.tar.gz"
    sha256 "041bed0852649cab7e4dcd4d87f9d1cc084467fb846e5b60015e014761d96414"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
    assert_match version.to_s, shell_output("bash -c '. #{bin}/awsume -v 2>&1'")

    file_path = File.expand_path("~/.awsume/config.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  PARTITION  ACCOUNT",
                 shell_output("bash -c '. #{bin}/awsume --list-profiles 2>&1'")
  end
end
