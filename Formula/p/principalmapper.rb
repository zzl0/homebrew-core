class Principalmapper < Formula
  include Language::Python::Virtualenv

  desc "Quickly evaluate IAM permissions in AWS"
  homepage "https://github.com/nccgroup/PMapper"
  url "https://files.pythonhosted.org/packages/3f/8c/3d2efe475e9244bd45e3a776ea8207f34a9bb15caaa02f6c95e473b2ada2/principalmapper-1.1.5.tar.gz"
  sha256 "04cb9dcff0cc512df4714b3c4ea63a261001f271f95c8a453b2805290c57bbc2"
  license "AGPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88129364b1771eba2faf4eb8ef4e57febcf635b833360e1bb18602e25e322505"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0b0609b68206f01b9f0b420831e9e303d9dd9e97dd6989222d13307c16f18fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40db4bf177682d1efe58ce309aeb052b2d04b3bfda841529f3711f89cce15971"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad1ea1e603edfa2278847f70e194565c883c4feeb3d47f6b5ae19fd54c08d33c"
    sha256 cellar: :any_skip_relocation, sonoma:         "807e6564b8b4c6419d6895bedc6b847f891f228bf5bf690c438903148392f5c2"
    sha256 cellar: :any_skip_relocation, ventura:        "fc7b301326ce7f99cc5ef04ef0690fe57960b5f114a4b5674ed3eddaa7202511"
    sha256 cellar: :any_skip_relocation, monterey:       "cceceaa1b6018b7e539ab6d539cb1733040b951430abcfe85fff61059f9a44d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7d9626874aa2df94cd4c3763ff45d3a51ac174be3ae6b7304e352107c51df50"
    sha256 cellar: :any_skip_relocation, catalina:       "571811598116caf816bd85365e15524bacb44b06fec98777505db53ee0c0b191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b881af0513ff8953dc5ef5f8d7fcf18ffad7b90c1186a32779c5aa438b62938"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/2e/9cb8adca433af2bb6240514448b35fa797c881975ea752242294d6e0b79f/botocore-1.31.61.tar.gz"
    sha256 "39b059603f0e92a26599eecc7fe9b141f13eb412c964786ca3a7df5375928c87"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  # Support Python 3.10, remove on next release
  patch do
    url "https://github.com/nccgroup/PMapper/commit/88bad89bd84a20a264165514363e52a84d39e8d7.patch?full_index=1"
    sha256 "9c731e2613095ea5098eda7141ae854fceec3fc8477a7a7e3202ed6c751e68dc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Account IDs:\n---", shell_output("#{bin}/pmapper graph list").strip
  end
end
