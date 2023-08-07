class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/34/6a/8e8734a47dad3cf6cbf4ba8631340814cd374ea58452133a62714dc6338b/fabric-3.2.1.tar.gz"
  sha256 "81293d7e2b509d37e51bb49a0151191455f5a7ea11ebaa158bdee995b844c668"
  license "BSD-2-Clause"
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d64f6cab7463fd01c4ef04ea40da4846617dce3894e36b047be342c75186a627"
    sha256 cellar: :any,                 arm64_monterey: "cd182da7be33dd885c4ee2f85e478b790b274b13dcfcac7c7fd7567209e1070f"
    sha256 cellar: :any,                 arm64_big_sur:  "ecff430f4df9b278bc49e45bfff50cd5f0be0ed4810533bd3622f5b5c38ec9d5"
    sha256 cellar: :any,                 ventura:        "cd70bcf6f7bc3b2092f8186c5f24a60685cf1ce4f1a656ba327b7d68a4970f36"
    sha256 cellar: :any,                 monterey:       "7f4a63d0b7bff6774672fafc8ee96dfb69eecc3b2a25509ee4dd19cf6eb052b1"
    sha256 cellar: :any,                 big_sur:        "b019a3527c25fe2a263170ea312a49f3c0107bef428db7c1c1b6c4b149669514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "995b0531b3711e02b91475166e233bba95db3f8af07cbbf61b9d7bd6badc1e29"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cffi"
  depends_on "pyinvoke"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/44/03/158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6/paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  def install
    virtualenv_install_with_resources

    # we depend on pyinvoke, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    pyinvoke = Formula["pyinvoke"].opt_libexec
    (libexec/site_packages/"homebrew-pyinvoke.pth").write pyinvoke/site_packages
  end

  test do
    (testpath/"fabfile.py").write <<~EOS
      from invoke import task
      import fabric
      @task
      def hello(c):
        c.run("echo {}".format(fabric.__version__))
    EOS
    assert_equal version.to_s, shell_output("#{bin}/fab hello").chomp
  end
end
