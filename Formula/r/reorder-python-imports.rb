class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/f2/a4/b9299bb0ce17c405fda20efa39f6993b418b10c765e978961f3c97254f4e/reorder_python_imports-3.12.0.tar.gz"
  sha256 "f93106a662b0c034ca81c91fd1c2f21a1e94ece47c9f192672e2a13c8ec1856c"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "532c0755c6f4d88265ba7a2139921f23e3382be54e815f9ef9fe8a877cbf3a57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44d27fc5bbf3addef5890df0afbc42df36ff2ea2ea0a69bb9438563bea142e2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b524242a72ee2c9a2bc8df0c605f33ad16841fdf61ec011eee0bb58bd4f88634"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80d848ca5e778047046932f8463d4508e5aaf211aaa784a6eda4c5390b1a4a79"
    sha256 cellar: :any_skip_relocation, sonoma:         "95a8feb1f47e5c57af5fc380766f9f6dfa32cd060a2591a1c5fc926dcb634f3a"
    sha256 cellar: :any_skip_relocation, ventura:        "df7ccb1fdc6de5e13430ac4b4b41c96f903242a520a8a16f8e85cd29659b32f5"
    sha256 cellar: :any_skip_relocation, monterey:       "75db721df6b20dc6297d8e672d91ede5a3c36c2d2021c2436077cdb56e99343d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f428ec3e9ddaa9a574d8957425386b2736cb26633fa490e8db667d9421ccfb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13df84fa6f80a6f330b9618a465b070b26dad233e6f058f98cd259fca7020c0f"
  end

  depends_on "python@3.11"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/7e/b6/6cdc486fced92110a8166aa190b7d60435165119990fc2e187a56d15144b/classify_imports-4.2.0.tar.gz"
    sha256 "7abfb7ea92149b29d046bd34573d247ba6e68cc28100c801eba4af17964fc40e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system "#{bin}/reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
