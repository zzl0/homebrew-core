class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https://github.com/wimglenn/johnnydep"
  url "https://files.pythonhosted.org/packages/ac/4f/a6e38abe80edd42b366fc3420542e548ac1039f514126db605ee5a09c4c9/johnnydep-1.20.3.tar.gz"
  sha256 "0f26a9e50e8f4d20eb7abbd2bd85fe352a6f28b5630999ee470c0d0c76c10911"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e293ee2301be8211c48c64d33092f7b66dbf9b974030266b62a93e088c0fb1a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0db7e4d2f82074be94e81b72e0bd0910a986918d6d42b6ce36346487095bc451"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a233db7683c728c0d29d873535e1dfb3dea47da7efe5df96e6f917e19aee7ded"
    sha256 cellar: :any_skip_relocation, sonoma:         "02346e35d2e901c0a2fcd0bbf56aa01d58209dcc4947ef12cf159622af454bea"
    sha256 cellar: :any_skip_relocation, ventura:        "c7ebe36400abf6fc72fc09912eb7ab543ed7f27b9491f4d898fcf3c138a84106"
    sha256 cellar: :any_skip_relocation, monterey:       "33710fa40ab1258bd67d7ba6bbbb3b779a72ed9562e34c1320b8abc836349779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8530ce47a06587de02d63da4912445ab6268ea8930414841f89e595e6e6d918b"
  end

  depends_on "python-packaging"
  depends_on "python-tabulate"
  depends_on "python-toml"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/45/66/29b55cc478fb15b8d50e63f4d7465d3123437369c0e6b86451d8739475cd/anytree-2.10.0.tar.gz"
    sha256 "a5e922bef6bb5a154f8d306d37b40ea21885e4143856a9206a14b791cfc26102"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "oyaml" do
    url "https://files.pythonhosted.org/packages/00/71/c721b9a524f6fe6f73469c90ec44784f0b2b1b23c438da7cc7daac1ede76/oyaml-1.0.tar.gz"
    sha256 "ed8fc096811f4763e1907dce29c35895d6d5936c4d0400fe843a91133d4744ed"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/99/4c/67e8cc235bbeb0a87053739c4c9d0619e3f284730ebdb2b34349488d9e8a/structlog-23.2.0.tar.gz"
    sha256 "334666b94707f89dbc4c81a22a8ccd34449f0201d5b1ee097a030b577fa8c858"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a4/99/78c4f3bd50619d772168bec6a0f34379b02c19c9cced0ed833ecd021fd0d/wheel-0.41.2.tar.gz"
    sha256 "0c5ac5ff2afb79ac23ab82bab027a0be7b5dbcf2e54dc50efe4bf507de1f7985"
  end

  resource "wimpy" do
    url "https://files.pythonhosted.org/packages/6e/bc/88b1b2abdd0086354a54fb0e9d2839dd1054b740a3381eb2517f1e0ace81/wimpy-0.6.tar.gz"
    sha256 "5d82b60648861e81cab0a1868ae6396f678d7eeb077efbd7c91524de340844b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/johnnydep johnnydep")
    resources.each do |r|
      assert_match r.name, output
    end
  end
end
