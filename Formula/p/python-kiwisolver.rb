class PythonKiwisolver < Formula
  desc "Efficient C++ implementation of the Cassowary constraint solving algorithm"
  homepage "https://github.com/nucleic/kiwi"
  url "https://files.pythonhosted.org/packages/b9/2d/226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85ea/kiwisolver-1.4.5.tar.gz"
  sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  license "BSD-3-Clause"

  depends_on "python-build" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "build", "--wheel"
      system python_exe, "-m", "pip", "install", *std_pip_args, Dir["dist/kiwisolver-*.whl"].first
      rm_rf "dist"
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import kiwisolver"
    end
  end
end
