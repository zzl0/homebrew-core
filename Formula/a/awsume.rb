class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  url "https://files.pythonhosted.org/packages/2f/d4/2f9621851aa22e06b0242d1c5dc2fbeb6267d5beca92c0adf875438793c2/awsume-4.5.3.tar.gz"
  sha256 "e94cc4c1d0f3cc0db8270572e2880c0641ce14cf226355bf42440b726bf453ef"
  license "MIT"
  revision 2
  head "https://github.com/trek10inc/awsume.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "091600515f6ef774162a6ab8682e4be717a3c76ffdd3f5fe8da2c94a1286cb2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34cc433dbf4dd082d192a7862cb3e67b04552e55b3ebc14543b74d87833af34b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ed015b727191d782e1c4141b4c7daf098df5a0ad09d106db91890b725c8ed78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb9b656e36b784a100ab2271b8c1a749cff32f50b74cacfabf165134145e6af6"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd7eb2898a6bd40682344a08c8f9b5688f26d31f710d78694f65a430bdb51f68"
    sha256 cellar: :any_skip_relocation, ventura:        "cf65963314679dfb6443327920402a9b63d23474a9a29a036addcb2a0bc09a7c"
    sha256 cellar: :any_skip_relocation, monterey:       "e29cbf8fed2726d1f43723ab239d9892b0ff129b182e40c287e52b49bbdd6cf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e09f9f12828086b892e57cc1295aa84bdc74bb4b1182757ba48639ff0873f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ab02ad5f98ce499784d7601b8cf4304544a17247f286764c14a3919d3688037"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "sqlite"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a8/23/ef75674c1ef3bf77479a5566a1a7c642206298feec1f7012e4710a5b35f4/boto3-1.28.58.tar.gz"
    sha256 "2f18d2dac5d9229e8485b556eb58b7b95fca91bbf002f63bf9c39209f513f6e6"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/77/1d/bd7a7383a2aff3cbf01c758a5507106ac7459707b241d8afbf336520f142/botocore-1.31.58.tar.gz"
    sha256 "002f8bdca8efde50ae7267f342bc1d03a71d76024ce3949e4ffdd1151581c53e"
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

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
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
    assert_match version.to_s, shell_output("bash -c '. #{bin}/awsume -v 2>&1'")

    file_path = File.expand_path("~/.awsume/config.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  ACCOUNT",
                 shell_output("bash -c '. #{bin}/awsume --list-profiles 2>&1'")
  end
end
