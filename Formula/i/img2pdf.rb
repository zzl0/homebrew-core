class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/56/a4/755e7c296d6e24e3e40b0f98e639ee93be1bd91c62ed698bbc7ceec420f6/img2pdf-0.5.0.tar.gz"
  sha256 "ae6c19731bde2551356c178bf356ca118ac32a232c737a14b423f8039df3c24b"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a93aa3091566600d462cdada6230f1f4e719936965b789dba7754606aabeb47a"
    sha256 cellar: :any,                 arm64_ventura:  "01650a4d1aa5234b48eeeee4209e9e71aa6a0ed0debaa3cd706a294a95c30954"
    sha256 cellar: :any,                 arm64_monterey: "ff3374f676856e052de7d1db31574dd21bb097d92dffc98e329f65fce265bee6"
    sha256 cellar: :any,                 sonoma:         "c348745f00f56765220dd0eaa23997c1bf83845d6e6a8260b19dc14f1b3b4ced"
    sha256 cellar: :any,                 ventura:        "008a2f535e03de53b70b65ec6b8c4d0575f3dc250bb72a422c2cdae2d61adbb6"
    sha256 cellar: :any,                 monterey:       "81c4510ca8e11eb6c72f29dbc87a8f9d5b5702f33ca913cd6557c28aa4d2d928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed561971b932a1b94a74d0f96dae9ea7dd37567633568a9f85de9fc0ffac077e"
  end

  depends_on "pillow"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "qpdf"

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/25/03/5d12db46d10d6f8979edaedf286f7c4f399c8b022ed653c5f78f6a74e0f4/pikepdf-8.5.3.tar.gz"
    sha256 "7b4303e9000375b4f6ff51779bd5ca72aba3befb01cfdb5530f4ebabdde3f82b"
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
