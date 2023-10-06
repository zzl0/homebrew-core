class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/8e/5c/18f534e16b193be36d140939b79a8046e07f343b426054c084b12d59cf0b/git-review-2.3.1.tar.gz"
  sha256 "24e938136eecb6e6cbb38b5e2b034a286b70b5bb8b5a2853585c9ed23636014f"
  license "Apache-2.0"
  revision 2
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1f756b99e24458d13e21c5aff1ae3fbfeaa5230b1eaf0c7c354ad241ca33612"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99e980092fb64d12462f0f573cf8707d57624c29ef0f86b1103be6495a6d58e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63a7c1879c747aa4571ac639c7b1ac7ecd55b05e4bc9f2fa9d43a92229e86b69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dd3a29e8954a9209c221571a8f1fb5ea6a77751216878d6019ad99504f8193c"
    sha256 cellar: :any_skip_relocation, sonoma:         "86bb164713b4a1a7b4d20aef02e706144931e975f7f7f176ea818a239074707f"
    sha256 cellar: :any_skip_relocation, ventura:        "9a03c2e4cd27503b17c36d79726551efa069a8ab4c4c077bed989832fc156ba4"
    sha256 cellar: :any_skip_relocation, monterey:       "472c583ed5f331f022052886c5f36d1567c01f872daf21fd93894996a38ddded"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a546d0572920a0eeef559299b5a94661eb64ad9c9122499ffa4c2a0957cfded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fca390df9939579efa74133d64237f129481b4231e6612addd20ce01b300bb2"
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
    man1.install Utils::Gzip.compress("git-review.1")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end
