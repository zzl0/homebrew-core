class PythonPlatformdirs < Formula
  desc "Python package for determining appropriate platform-specific dirs"
  homepage "https://platformdirs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/31/28/e40d24d2e2eb23135f8533ad33d582359c7825623b1e022f9d460def7c05/platformdirs-4.0.0.tar.gz"
  sha256 "cb633b2bcf10c51af60beb0ab06d2f1d69064b43abf4c185ca6b28865f3f9731"
  license "MIT"

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
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
      system python_exe, "-c", "import platformdirs"
    end
  end
end
