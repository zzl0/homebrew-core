class GitReview < Formula
  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/8e/5c/18f534e16b193be36d140939b79a8046e07f343b426054c084b12d59cf0b/git-review-2.3.1.tar.gz"
  sha256 "24e938136eecb6e6cbb38b5e2b034a286b70b5bb8b5a2853585c9ed23636014f"
  license "Apache-2.0"
  revision 3
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfc345d706adf37a43b6dfbbd09e97c17c8d48c6d76dc2291606ee41844185b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cba292566603f89c722a430308c5bcfa43e867085836e613c886cd1fefbfe23a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07b1ec48d55c4a5eaa7fac678c2479b22e377ac47afd55339856d6e04d0e8e69"
    sha256 cellar: :any_skip_relocation, sonoma:         "193a1eff4f5810c6a28fc7bd058a1b834a080056f966831c48e8329f24524e29"
    sha256 cellar: :any_skip_relocation, ventura:        "bd5557008d90abc65d6f868e0fd32e1ae538f91b47e0e0f362c6ee226288d59b"
    sha256 cellar: :any_skip_relocation, monterey:       "db5407dff0d547028e733d438142f98b7d4555ba500e7f593b5537b8bd7234c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21f1110e2bc0bdfd47c9ca25458063cb94abbc7df6352a6eddc79e17191a7b27"
  end

  depends_on "python-requests"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
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
