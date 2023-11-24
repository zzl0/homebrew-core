class PythonAbseil < Formula
  desc "Abseil Common Libraries (Python)"
  homepage "https://abseil.io/docs/python/"
  url "https://files.pythonhosted.org/packages/c6/09/fe8d9ab3e640b12322f8f73448db3428bf417b7dcfe14702fc7413e6c5c9/absl-py-2.0.0.tar.gz"
  sha256 "d9690211c5fcfefcdd1a45470ac2b5c5acd45241c3af71eed96bc5441746c0d5"
  license "Apache-2.0"

  depends_on "python-setuptools" => :build
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
      system python_exe, "-c", "from absl import app"
    end
  end
end
