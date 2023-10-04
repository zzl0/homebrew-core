class Compiledb < Formula
  include Language::Python::Virtualenv

  desc "Generate a Clang compilation database for Make-based build systems"
  homepage "https://github.com/nickdiego/compiledb"
  url "https://files.pythonhosted.org/packages/76/62/30fb04404b1d4a454f414f792553d142e8acc5da27fddcce911fff0fe570/compiledb-0.10.1.tar.gz"
  sha256 "06bb47dd1fa04de3a12720379ff382d40441074476db7c16a27e2ad79b7e966e"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d7d593846a5edf8ce2e468f74f3a2e6d2541667aee380ec853f921d903190b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99d4ad0e016adfa94460cc9c886cc8dcceacba9ccbaf51d04d8e3b7028d58d61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd93b12502449ec25be15c4e247b940ba85f4fb51d641f750268967331fba099"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8d9505131e721298fad7ab7b89bc042954ec8275e8b17a396c931c2b1d84389"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a6d90b4d7fe4d24fc11ee1efa151102ac5a2aef1be7466c18ec5f4bc8e2ada4"
    sha256 cellar: :any_skip_relocation, ventura:        "ce10a050579461e0cc548dd2c9a6306618c9912f2390aa0d84c2cf0b25db1d93"
    sha256 cellar: :any_skip_relocation, monterey:       "a2572bb2b079e002259858088496a61d9bc76d7ffadd6e37b8cbd05cbc3495d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "52aa66cc118dd3c8105ea952276c6227dad47a1634b2c8b533f1b305035f9a22"
    sha256 cellar: :any_skip_relocation, catalina:       "5a2d47563121d3383bf89e2b5c2f0ccd72d90d7df1e54b4bb4c8873bb9492565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "980ef38bab346737d8d166410fa7bc46d32a86ee11fcf1b438b8bfda06e180a0"
  end

  depends_on "python@3.12"

  resource "bashlex" do
    url "https://files.pythonhosted.org/packages/76/60/aae0bb54f9af5e0128ba90eb83d8d0d506ee8f0475c4fdda3deeda20b1d2/bashlex-0.18.tar.gz"
    sha256 "5bb03a01c6d5676338c36fd1028009c8ad07e7d61d8a1ce3f513b7fff52796ee"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "shutilwhich" do
    url "https://files.pythonhosted.org/packages/66/be/783f181594bb8bcfde174d6cd1e41956b986d0d8d337d535eb2555b92f8d/shutilwhich-1.1.0.tar.gz"
    sha256 "db1f39c6461e42f630fa617bb8c79090f7711c9ca493e615e43d0610ecb64dc6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all:
      	cc main.c -o test
    EOS
    (testpath/"main.c").write <<~EOS
      int main(void) { return 0; }
    EOS

    system "#{bin}/compiledb", "-n", "make"
    assert_predicate testpath/"compile_commands.json", :exist?, "compile_commands.json should be created"
  end
end
