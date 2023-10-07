class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.com/gitlint/"
  url "https://files.pythonhosted.org/packages/73/51/b59270264aabcab5b933f3eb9bfb022464ca9205b04feef1bdc1635fd9b4/gitlint_core-0.19.1.tar.gz"
  sha256 "7bf977b03ff581624a9e03f65ebb8502cc12dfaa3e92d23e8b2b54bbdaa29992"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfa2f4df4ad580d962068df6ef5ef527adbd26e93309f63146f5deb17d1e531d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d405098bd2a0e76aa35c2c962a78047eb9813bd2e8137d32e77465ec65a1baa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "729efc2e3ad555e6d77fa801042a157bfa2182738794a1b80fd4345aa0b8ef30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c0961fb81b39f533e9448b51f62579be7fd2870ad96b05bf06ece1dc0cf9d4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "17f708964fc124bca156a2bc139d1a5dd526c6f66a97a9ad633fea141cf0e3c5"
    sha256 cellar: :any_skip_relocation, ventura:        "7d3d8661621b9a761425df188984da146c615f5a2d9e89d29615f86d2ebb4ce2"
    sha256 cellar: :any_skip_relocation, monterey:       "c25ba5a796a144b68544c08eb44a1d23f89448b42c7195e6637e3a21c214f710"
    sha256 cellar: :any_skip_relocation, big_sur:        "c75117e820488a1eeeef95548342f64632e626c8c31b2570f769faa15a3a6ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e15b677036ec1ede61fdc4d533fc92f20e0faa99f29c2eeaa7b713b176ad1c0c"
  end

  depends_on "python@3.12"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/cd/51/7355831d8e1cee8348157d769ccda8a31ca9fa0548e7f93d87837d83866d/sh-2.0.6.tar.gz"
    sha256 "9b2998f313f201c777e2c0061f0b1367497097ef13388595be147e2a00bf7ba1"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  def install
    virtualenv_install_with_resources

    # Click does not support bash version older than 4.4
    generate_completions_from_executable(bin/"gitlint", shells:                 [:fish, :zsh],
                                                        shell_parameter_format: :click)
  end

  test do
    # Install gitlint as a git commit-msg hook
    system "git", "init"
    system "#{bin}/gitlint", "install-hook"
    assert_predicate testpath/".git/hooks/commit-msg", :exist?

    # Verifies that the second line of the hook is the title
    output = File.open(testpath/".git/hooks/commit-msg").each_line.take(2).last
    assert_equal "### gitlint commit-msg hook start ###\n", output
  end
end
