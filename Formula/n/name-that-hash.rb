class NameThatHash < Formula
  include Language::Python::Virtualenv

  desc "Modern hash identification system"
  homepage "https://nth.skerritt.blog/"
  url "https://files.pythonhosted.org/packages/7a/d6/5bea2b09a8b4dbfd92610432dbbcdda9f983be3de770a296df957fed5d06/name_that_hash-1.11.0.tar.gz"
  sha256 "6978a2659ce6d38c330ab8057b78bccac00bc3e87138f2774bec3af2276b0303"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/HashPals/Name-That-Hash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e3b6908160d20dcb60261e789e56b696ac39d76d4dbc6e4331a890400766f84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4020cbb09cbe8736a98bf84fce42b9a56391abc6cf425ce4b0891e758b10b7b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e6c3c27debfd317c58804ec0261ff40656d85672551c24eb120d7df4b8aca09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b19a1655bc7711f5c231b30851812cd9e79e8af1a2733ad8f58796a4b9f693c"
    sha256 cellar: :any_skip_relocation, sonoma:         "17bae696c071aa7d12b85e31de1999d71ef908c176ea70699613295a882cc2a2"
    sha256 cellar: :any_skip_relocation, ventura:        "4b12a7e90ccd7ff34b8f65a250ee64c6ad5e41d63e01c8b3d0651ea85b57913f"
    sha256 cellar: :any_skip_relocation, monterey:       "a4cc533509369346aa8386b3e91327bc0b5a2838916229ce8d8fafac70ac239f"
    sha256 cellar: :any_skip_relocation, big_sur:        "504dbe235e16c8321c68bbcfce7258b24af6da3d754d5b9d11882da7c71d2c6a"
    sha256 cellar: :any_skip_relocation, catalina:       "ad00a4e99937b98ac9c1e317e8d3e544bc954a46b9fcbc4fdef343ce381a97f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5635edb4f1faa51b8096a8b55e73e22e95319634a29421e800c808e15ba5a721"
  end

  depends_on "pygments"
  depends_on "python-click"
  depends_on "python@3.12"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-name_that_hash.pth").write pth_contents
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}/nth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "MD5, HC: 0 JtR: raw-md5 Summary: Used for Linux Shadow files.\n", output

    system python3, "-c", "from name_that_hash import runner"
  end
end
