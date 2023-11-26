class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/36/92/6ac4d61951ba507b499f674c90dfa7b48fa776b56f6f068507f8751c03f1/img2pdf-0.5.1.tar.gz"
  sha256 "73847e47242f4b5bd113c70049e03e03212936c2727cd2a8bf564229a67d0b95"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "492b0d07a574f776f02af896bdaff257492d086ee6dfaddf9d7f07ff735b5716"
    sha256 cellar: :any,                 arm64_ventura:  "309b4c9fd9da6b1bb858d01124e3961c59605580bd902278d5f4f0e6e6cd0c53"
    sha256 cellar: :any,                 arm64_monterey: "f632abe8306b30d27742dcdc201985ef0a389b96bb70896aac697506a45d39ae"
    sha256 cellar: :any,                 sonoma:         "36f941f12619c369374271d943d922ff46050f60d1307c5215e68e32b114401a"
    sha256 cellar: :any,                 ventura:        "b42e9e40a5c2dd209bab9bf759b0eb007225e73f9abd8716448f4e863497155a"
    sha256 cellar: :any,                 monterey:       "74c4047679ebcb7b918cb02a6938d19dc49b1cbda519294487173fe83acf6a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e6e6fcc37339427d439ec1be62ca53f436cf8e391833e8597b131deb3257f47"
  end

  depends_on "pillow"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "qpdf"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/38/e8/c7642da0b774d42a259bdb450aba0d34aee65bf3f6641c7a7f3c83ac7297/pikepdf-8.7.1.tar.gz"
    sha256 "69d69a93d07027e351996ef8232f26bba762d415206414e0ae3814be0aee0f7a"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
