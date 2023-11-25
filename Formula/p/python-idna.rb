class PythonIdna < Formula
  desc "Internationalized Domain Names in Applications (IDNA)"
  homepage "https://github.com/kjd/idna"
  url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
  sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9646a15f727c1a9785303550c491c8f6b300323e9f362e9ef68427361cb42079"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cb271ef1d35bee074250488f18c15dbc2cb8c5b017ce64d74165f5d34ad98c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e2849adf49db35a5fdf1777f2a798c2dcc540d12e4884a89b6629c8fd6cd72f"
    sha256 cellar: :any_skip_relocation, sonoma:         "23d22f4ae1cf269f424d7589fc06895610c03b332e93e04d004a0ce945bdb656"
    sha256 cellar: :any_skip_relocation, ventura:        "901f66403219134b439407a96e49557a104def5a2bdfbf61a9be5f741b173b35"
    sha256 cellar: :any_skip_relocation, monterey:       "21b602302c863d329615b0b13be526550b5feccc8ed94ef843b3d079a8b8dfa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a63c27be5450277c302b82495fa3675ee2889c2452e234547c4b0897cc26f228"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import idna"
    end
  end
end
