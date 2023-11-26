class ArxivLatexCleaner < Formula
  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/ba/75/626014f47d51aad0e6ef39a051ba7fe24a4e4f8b0bf23750909615d62864/arxiv_latex_cleaner-1.0.1.tar.gz"
  sha256 "d9fae07f82f8ad19704ff58fe4e1ed7fc668cc28ea6238c13bf5d687c988d79c"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a1c337a3db307e559ead0dcfdc44378886e11d218a639ae26ae4a0dde3fb13e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aca841acaf15a0d97155fe05daf99070005683409fcad42959df06a1531f54dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b62ebfea37df88758c3bc34f540edc9d819ac6040d11ec4d7afd1303bf418453"
    sha256 cellar: :any_skip_relocation, sonoma:         "05f6bd6f5db883a7c0bea1eaa1b2a60a1bef8379298e17bb08811afe205a5c9d"
    sha256 cellar: :any_skip_relocation, ventura:        "768ee6afbef80a82c9fe3130d2e679d658a589335fe8f28ff841e729a9f2a01a"
    sha256 cellar: :any_skip_relocation, monterey:       "fb4daee3eebc170cfdbad210decd3d6cb4097301af5cb4d3080c4396a8d5a2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed1b43f5f808505364aa9fd8a23d7330ed44ce8756c27180d446f980d7c74d9a"
  end

  depends_on "python-setuptools" => :build
  depends_on "pillow"
  depends_on "python-abseil"
  depends_on "python-regex"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~EOS
      % remove
      keep
    EOS
    system bin/"arxiv_latex_cleaner", latexdir
    assert_predicate testpath/"latex_arXiv", :exist?
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
