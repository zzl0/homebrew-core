class PythonBrotli < Formula
  desc "Python bindings for the Brotli compression library"
  homepage "https://github.com/google/brotli"
  url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
  sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  license "MIT"
  head "https://github.com/google/brotli.git", branch: "master"

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
        .map(&:to_formula)
        .sort_by(&:version)
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
      system python_exe, "-c", "import brotli"
    end
  end
end
