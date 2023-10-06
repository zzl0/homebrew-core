class Grokmirror < Formula
  include Language::Python::Virtualenv

  desc "Framework to smartly mirror git repositories"
  homepage "https://github.com/mricon/grokmirror"
  url "https://files.pythonhosted.org/packages/b0/ef/ffad6177d84dafb7403ccaca2fef735745d5d43200167896a2068422ae89/grokmirror-2.0.11.tar.gz"
  sha256 "6bc1310dc9a0e97836201e6bb14ecbbee332b0f812b9ff345a8386cb267c908c"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/mricon/grokmirror.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5ffc59c67820633cc877e4d325bf268882e20a0957e9beddaf0938894a8455a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b98b7d2ae38776e116471d4aa93752179dd6cf0178ca2c963dab1a5ce149af8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cd1c6f82c4b6786747aadd7c66a184874290c6ebaf2140900b23c6fa4a62917"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e71ad6585d8fdbe72e5dd132cf4d20482002c569f3fb9ce83e0be0efc8b7f75"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ed2e41bac9ea83ea2df5180f0a2181edd52051dcc4cff32a0b4f1d0265505a2"
    sha256 cellar: :any_skip_relocation, ventura:        "acae5a92fa6062106d7abe579db63da6e252a7c90173a2d76c9521aaa2ee46c3"
    sha256 cellar: :any_skip_relocation, monterey:       "c8a222768f1fa3ded6b38fea8c5963d27e4ce80d496fbaaf8f26f1c8b2be18dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "99ce644f6574c85120f619b503f80f729d82d1472d6e53d54edb15640bd0a94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3749e3ddcf48a04513d603e2d533c998fde630c106117a11c506450b39c8af81"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "repos/repo" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
      (testpath/"repos/repo/test").write "foo"
      system "git", "add", "test"
      system "git", "commit", "-m", "Initial commit"
      system "git", "config", "--bool", "core.bare", "true"
      mv testpath/"repos/repo/.git", testpath/"repos/repo.git"
    end
    rm_rf testpath/"repos/repo"

    system bin/"grok-manifest", "-m", testpath/"manifest.js.gz", "-t", testpath/"repos"
    system "gzip", "-d", testpath/"manifest.js.gz"
    refs = Utils.safe_popen_read("git", "--git-dir", testpath/"repos/repo.git", "show-ref")
    manifest = JSON.parse (testpath/"manifest.js").read
    assert_equal Digest::SHA1.hexdigest(refs), manifest["/repo.git"]["fingerprint"]
  end
end
