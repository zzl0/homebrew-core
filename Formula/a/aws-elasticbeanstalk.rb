class AwsElasticbeanstalk < Formula
  include Language::Python::Virtualenv

  desc "Client for Amazon Elastic Beanstalk web service"
  homepage "https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html"
  url "https://files.pythonhosted.org/packages/ec/5e/96dbeec0f796ac7928f52ed61c6b3a44764ae4113185bb1e08fc4d758ba7/awsebcli-3.20.10.tar.gz"
  sha256 "8599d0e2ca70e42ee55948e6f58f65ea06596143c556925572fbf80ce705548d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "77a32672ba85546f9d405bf30b779a89bd2b5571e059f8bf7cf0aa6c94c93dfa"
    sha256 cellar: :any,                 arm64_ventura:  "0fa6662f7016f219e9ef28aa6ec12ebdfc34e6d849807a2fe3ddd62f6f1c59ca"
    sha256 cellar: :any,                 arm64_monterey: "9f0ef26ec9ed9534a632280c11ec60bdf6f127aef6740ba9d0d878537d3745f6"
    sha256 cellar: :any,                 arm64_big_sur:  "bff8553a218b227ae39bdf0fbc73275a59644fcbe31027f6e776aca14f71d82a"
    sha256 cellar: :any,                 sonoma:         "793d36ea78e49472a4cb96888dc100c062f0389b5515752df6a339cd44ec9717"
    sha256 cellar: :any,                 ventura:        "64296bea6913585e91136c69c00aef728417bb99670a7bb46e073f5500103f1e"
    sha256 cellar: :any,                 monterey:       "975cffa344d6443a56925ca945f3888c2d8eb0d75dda136605ac067e0acefade"
    sha256 cellar: :any,                 big_sur:        "a4514765bf73a6f5eeb6bbce657e9a4f5fdf54b65517c22bbb04e3e39cf314b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "493088327fb57f086c1fbc1b23b50729e3ba8eea675e35bbdb4ba684845cb0af"
  end

  # `pkg-config` and `rust` are for bcrypt
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libffi"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a6/4f/4c2b7d96dd50aed47db6cccf6c1c089853f6474e1d1da5c5aa320d7d4157/botocore-1.31.63.tar.gz"
    sha256 "6e582c811ea74f25bdb490ac372b2645de4a60286b42ddd8c69f3b6df82b6b12"
  end

  resource "cement" do
    url "https://files.pythonhosted.org/packages/70/60/608f0b8975f4ee7deaaaa7052210d095e0b96e7cd3becdeede9bd13674a1/cement-2.8.2.tar.gz"
    sha256 "8765ed052c061d74e4d0189addc33d268de544ca219b259d797741f725e422d2"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/24/9f/a9ae1e6efa11992dba2c4727d94602bd2f6ee5f0dedc29ee2d5d572c20f7/pathspec-0.10.1.tar.gz"
    sha256 "7ace6161b621d31e7902eb6b5ae148d12cfd23f4a249b9ffb6b9fee12084323d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/d4/52/3be868c7ed1f408cb822bc92ce17ffe4e97d11c42caafce0589f05844dd0/semantic_version-2.8.5.tar.gz"
    sha256 "d2cb2de0558762934679b9a104e82eca7af448c9f4974d1f3eeccff651df8a54"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/eb init --region=us-east-1 --profile=homebrew-test", 4)
    assert_match("ERROR: InvalidProfileError - The config profile (homebrew-test) could not be found", output)
  end
end
