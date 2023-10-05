class GitDeleteMergedBranches < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to delete merged Git branches"
  homepage "https://github.com/hartwork/git-delete-merged-branches"
  url "https://files.pythonhosted.org/packages/69/e1/377ded5fd14801bd7f3174ab429882d85086e34fe0a0eec308c160c803f4/git-delete-merged-branches-7.4.0.tar.gz"
  sha256 "b976b7b2210a1dab728e654e1b023f8e5309d98dc14730bfb613e893604847e5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5cf4cb8f786e72e3297a960b340f1ebed926b559fbddbbd2fd0b78e8ca7eb81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1f4cadd23d7ae986e1cd277b4671285c5cb9d37b82a56cf5d5bded60c2c66dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ba8bdbfd1e8a48055f4ccf9c80555f30493b81d22275ea8c6f1f068aea5993b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ee73deb52b0d188264da540f96117a68ec47a23b5d48bcff443a30051fe1fd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "60b2fa65f86e932d3931d477fbe68b5966cbcdc470d34443c5b52fdb6adf7c5e"
    sha256 cellar: :any_skip_relocation, ventura:        "32b93603171ff630752789326d73133cfd34d82992d441adbc24fb8141ff3919"
    sha256 cellar: :any_skip_relocation, monterey:       "b03b8a74a640775cad3e87ae9f57b78f3e9fc25d369fa52997edfc3e6614a53b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d03ae011563b36c9bb3a21b0d409de1c93d17b2e064fdb217edf46604bb34104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d1a952e80df638527282ce31225320e9300227fcfacbbf8ba36135cdab8441"
  end

  depends_on "python@3.12"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    origin = testpath/"origin"
    origin.mkdir
    clone = testpath/"clone"

    cd origin do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@example.com"
      system "git", "commit", "--allow-empty", "-m", "Initial commit"
    end

    system "git", "clone", origin, clone

    cd clone do
      system "git", "config", "remote.origin.dmb-enabled", "true"
      system "git", "config", "branch.master.dmb-required", "true"
      system "git", "config", "delete-merged-branches.configured", "5.0.0+"
      system "git", "checkout", "-b", "new-branch"
      system "git", "checkout", "-"
      system "git", "delete-merged-branches", "--yes"
      branches = shell_output("git branch").split("\n")
      assert_equal 1, branches.length
    end
  end
end
