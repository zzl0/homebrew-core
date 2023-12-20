class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/63/33/7ca51f30db49eb0bba66d8dffcea4129efb80bf23882f7c0d79d6b819c03/MapProxy-2.0.0.tar.gz"
  sha256 "93073891315dd37f870d5e340cbe0bd24264a56634df44913edd5cefe35cf19d"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "b5c14d783b11413e42b2d03577485ee70d1b10ea1ffc05371b559aafa938c214"
    sha256 cellar: :any,                 arm64_ventura:  "687a7c9e3fb4149243698809b029d8af44daf0c86e29a9355d75e6c11dbd4167"
    sha256 cellar: :any,                 arm64_monterey: "6e34e109fa0a42c3732353863853a9cdfd9ace585e6c6399dfa895c2e277ef8a"
    sha256 cellar: :any,                 sonoma:         "e19b4d8f69457cbd87a66786bce575d0978e471e51a7ba502b55841322578d9e"
    sha256 cellar: :any,                 ventura:        "01109ae42429b2b4070f9aa56bab4b6cdea3c4e749888388b1b279b38d17679e"
    sha256 cellar: :any,                 monterey:       "20442865c78a9f962379811bf8919e405d8a9e08cf623e09558083f390b070c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b48d916430a9594c6f250cd2e7068f7d30a81aa8ad4a794d9e5547fb82acede3"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/7d/84/2b39bbf888c753ea48b40d47511548c77aa03445465c35cc4c4e9649b643/pyproj-3.6.1.tar.gz"
    sha256 "44aa7c704c2b7d8fb3d483bbf75af6cb2350d30a63b144279a09b75fead501bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
