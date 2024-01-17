class ArxivLatexCleaner < Formula
  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/38/fb/139464323ae1f8c623b0b61c21d276264c009b3908b3af541408d0044234/arxiv_latex_cleaner-1.0.3.tar.gz"
  sha256 "c2a0996c5c4bebfd91fed0cb16b16644856b9221574c8a1326069de80d1edf92"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c51d6b5e448e6939e40f4cb9ea6ac1af06ce2938ec11c6b69278542b55b82a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40bf2ecdbbf8cad2902d41d44435c3548c2156e5bb7b2a0185be6a5e12ec54b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f8eac26415bd91edab1dc37457f74695a4359e95551eccf3a20145696e37a4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "232b0c24ad9152ca00343ffc90568906250fab354abd07a01f6712ff4c1edf39"
    sha256 cellar: :any_skip_relocation, ventura:        "0aa3e80e4f2949e43e7595cff86bbe613adcb17069ff7de4a1f31219d61b1cbc"
    sha256 cellar: :any_skip_relocation, monterey:       "0ccedb396bf5705e33c15072f7dea652d5a11726d33186ce7ae680d628619328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb9abd94331a9adda204ed7708cbfd1b8dffa9d973d5c5d7e37b892b1857fc3d"
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
