class PythonFlitCore < Formula
  desc "Simplified packaging of Python modules"
  homepage "https://flit.pypa.io/"
  url "https://files.pythonhosted.org/packages/c4/e6/c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80/flit_core-3.9.0.tar.gz"
  sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  license "BSD-3-Clause"

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

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
      system python_exe, "-c", "import flit_core"
    end
  end
end
