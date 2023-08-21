class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/4c/5d/4734f4808f63e8b7897cef965a5413e94845eafbc256f70126c0c462a84d/vulture-2.9.1.tar.gz"
  sha256 "b6a2aa632b6fd51488a8eeac650ab4a509bb1a032e81943817a8a2e6a63a30b3"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dfb677fac27ab5c1add1ea06697095fb8efb1f5a7dc9ec1090b69036a40229a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0335cf0d45f8e47ab0827198c6408bc4a6e2b1fe3b13b8412453287854f23ece"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1b3798014ff50c56bb841e30d97cc0ed9730037be87a31fc13f6364f25dc8e3"
    sha256 cellar: :any_skip_relocation, ventura:        "f5244cb44a2ef411006e6e68d886393852512a2b5ab911023ea1638ab46f432f"
    sha256 cellar: :any_skip_relocation, monterey:       "397a2762fe341859173fa2333d307f9029c9cc3dc26625f1328b42a5020d48aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "59ee4c5333e9782872ae022ca673ba91d1fe0d3ef2873359ab21fef41e8691a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa766ade27be69262b9e7da71b943cbb418a08acd50e7c8bba7a5bca7167b9c"
  end

  depends_on "python-toml"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version")

    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 3)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end
