class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/a3/91/3522a1fbefcc02d3d496854aea81b2b01a6e388bdb27ca0be39a91a43711/txt2tags-3.8.tar.gz"
  sha256 "379869e866ed85225181ac65583827781a166c907de8bb40a9f3daf7b16c3483"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e25da3bd37834c96469ce32b195353728175cc3d1fdd37acfd7791c6c65f2883"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdb5181c1343eceb89f6dd5321569b96a4c71ab5be79e2bbfd22ca6237a3508e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22720ae006780efef0a675ca7cf7e477bc4371dfaee25efb4cf627444430b3be"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddb84e6a2c62887122832feb6bc121a1059a0a794b55365196e05f78939676c2"
    sha256 cellar: :any_skip_relocation, ventura:        "fddccc19e1ff4fc3e2583f8dd15c1c0e1bc6ebd283321623eaa45308a4b9fda3"
    sha256 cellar: :any_skip_relocation, monterey:       "ab9be9c291e92b9fd03775a494b1f1712382e733f8bc99900f5c40f65437417f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "693ddde81b03c0cb80ef193154b9ec72d0f233e32c59757054126409c7d32729"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match "<h1>Title</h1>", File.read("test.html")
  end
end
