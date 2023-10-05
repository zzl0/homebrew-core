class Gitup < Formula
  include Language::Python::Virtualenv

  desc "Update multiple git repositories at once"
  homepage "https://github.com/earwig/git-repo-updater"
  url "https://files.pythonhosted.org/packages/7f/07/4835f8f4de5924b5f38b816c648bde284f0cec9a9ae65bd7e5b7f5867638/gitup-0.5.1.tar.gz"
  sha256 "4f787079cd65d8f60c5842181204635e1b72d3533ae91f0c619624c6b20846dd"
  license "MIT"
  revision 9
  head "https://github.com/earwig/git-repo-updater.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19efdb1f33213ecaa191f972b6e43f10eea08a379846a69c79117e104a765f4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ba91fe9d81a5064ed91e422bdbd71aac5733d1c1cb5765d1295e7cbfa5174e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f8745a3dfae9f2686e24ba6e88625e55dbabfef7d67d4d75190642cd283821c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76255fb75f9b0bce086ec61e860bef614b0df0e200d7c532c59f27e53b13470d"
    sha256 cellar: :any_skip_relocation, sonoma:         "22c4b0ad76caafee42a7e20140f7094dc94e3c3eb62c86c14bde2da2392fc3c7"
    sha256 cellar: :any_skip_relocation, ventura:        "a94517352ad8f0db0804bbad73fa2013cd983ba71880a9ce7d92e147378b98bb"
    sha256 cellar: :any_skip_relocation, monterey:       "df7444b3554c68fa33f43d3e69f2d18a19c019e8134539abafda58b4623475bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d092919bfb6c1d6d9b955f13a5f416f405abf4f14358bbc7667c9c6db948d6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09343b5e64c30ad9a9de434c49f829c5514899379f0ce605bd3d120554120b8e"
  end

  depends_on "python@3.12"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c6/33/5e633d3a8b3dbec3696415960ed30f6718ed04ef423ce0fbc6512a92fa9a/GitPython-3.1.37.tar.gz"
    sha256 "f9b9ddc0761c125d5780eab2d64be4873fc6817c2899cbcb34b02344bdc7bc54"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  def install
    virtualenv_install_with_resources
  end

  def prepare_repo(uri, local_head)
    system "git", "init"
    system "git", "remote", "add", "origin", uri
    system "git", "fetch", "origin"
    system "git", "checkout", local_head
    system "git", "reset", "--hard"
    system "git", "checkout", "-b", "master"
    system "git", "branch", "--set-upstream-to=origin/master", "master"
  end

  test do
    first_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "first" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", first_head_start)
    end

    second_head_start = "f863d5ca9e39e524e8c222428e14625a5053ed2b"
    mkdir "second" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-cask-games.git", second_head_start)
    end

    system bin/"gitup", "first", "second"

    first_head = Utils.git_head(testpath/"first")
    refute_equal first_head, first_head_start

    second_head = Utils.git_head(testpath/"second")
    refute_equal second_head, second_head_start

    third_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "third" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", third_head_start)
    end

    system bin/"gitup", "--add", "third"

    system bin/"gitup"
    third_head = Utils.git_head(testpath/"third")
    refute_equal third_head, third_head_start

    assert_match %r{#{Dir.pwd}/third}, `#{bin}/gitup --list`.strip

    system bin/"gitup", "--delete", "#{Dir.pwd}/third"
  end
end
