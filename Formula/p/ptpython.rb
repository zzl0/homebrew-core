class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/46/56/56cdf93d1633cba2b16486aa27978893ab3791dae51b27068e09d08bd300/ptpython-3.0.26.tar.gz"
  sha256 "c8fb1406502dc349d99c57eaf06e7116f3b2deac94f02f342bae68708909f743"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04b14d3a1b599721dc41360f375c5029059d8a08242d16a3495249a03c8726fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfddce9f859b9b47ebbcd9d30326e64888a2f3a4b248c6a6cb834369edc81d6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f49614db1e7efe490e6fd8ffec1ca37f664ae56abf47094f77f3ca258f671431"
    sha256 cellar: :any_skip_relocation, sonoma:         "679cff5d2226e7dfc593a3607ab9ba692308e4ddcc50fae06a6ed7dedc498a04"
    sha256 cellar: :any_skip_relocation, ventura:        "f4a06bef4a18845e85af099a63e976b3971b4c1ddb17a89535963d7de8c7607f"
    sha256 cellar: :any_skip_relocation, monterey:       "8d944463f583bd7752e5b62fd1da986a83eae3c74882fcdcba0b81432e30067c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fca01b24dbecbaa86d9402ca633bdca179d9e24af665fd034b0872186414d7fe"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/d6/99/99b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0a/jedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end
