class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://files.pythonhosted.org/packages/87/40/07b58c29406ad9cc8747e567e3e37dd74c0a8756130ad8fd3a4d71c796e3/ERAlchemy-1.2.10.tar.gz"
  sha256 "be992624878278195c3240b90523acb35d97453f1a350c44b4311d4333940f0d"
  license "Apache-2.0"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5006be4e877efa026d83337d5414a7d0137db77c7851b778ca66344686d66986"
    sha256 cellar: :any,                 arm64_ventura:  "d9a7e039613efb2f43aef46a1a5dbcfaa023492980669033c499f1a131fc1fdd"
    sha256 cellar: :any,                 arm64_monterey: "fb737dbe25a1db5c7a9753b46accbb874e19e9c72aa8a7eecc265d87b4f8bdd2"
    sha256 cellar: :any,                 arm64_big_sur:  "faf8dbcd53995a42dcefa37734951a6f406f394b682ee453c273634664977009"
    sha256 cellar: :any,                 sonoma:         "e1008873b5e2571e01e6934ff9d1255eb6bd8c7eb81434ecff5b8e94e43050cb"
    sha256 cellar: :any,                 ventura:        "3536df041f23e0ba8c2c83d8bf35c579985ef5bdbe748e056e84a684d31d1930"
    sha256 cellar: :any,                 monterey:       "7b4299e2e6c576debd6b58fee020da258fe500829cf34c681b3840997f137c51"
    sha256 cellar: :any,                 big_sur:        "4fd5a115f664cc215f443d1e6e5744c558579595bfa8b6bd8de9b56a684cde00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272c801bd1fd6068dd1e9899ba3c08233c95d38e631e328b607fac4bb36af430"
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/19/db/cc09516573e79a35ac73f437bdcf27893939923d1d06b439897ffc7f3217/pygraphviz-1.11.zip"
    sha256 "a97eb5ced266f45053ebb1f2c6c6d29091690503e3a5c14be7f908b37b06f2d4"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/ae/e2/47f40dc06472df5a906dd8eb9fe4ee2eb1c6b109c43545708f922b406acc/SQLAlchemy-2.0.22.tar.gz"
    sha256 "5434cc601aa17570d79e5377f5fd45ff92f9379e2abed0be5e8c2fba8d353d2b"
  end

  resource "er_example" do
    url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/v1.1.0/example/newsmeme.er"
    sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| r.name == "er_example" }
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/eralchemy", "-v"
    resource("er_example").stage do
      system "#{bin}/eralchemy", "-i", "newsmeme.er", "-o", "test_eralchemy.pdf"
      assert_predicate Pathname.pwd/"test_eralchemy.pdf", :exist?
    end
  end
end
