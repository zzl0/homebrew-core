class PythonCachetools < Formula
  desc "Extensible memoizing collections and decorators"
  homepage "https://cachetools.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/10/21/1b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5/cachetools-5.3.2.tar.gz"
  sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  license "MIT"

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
      system python_exe, "-c", "from cachetools import cached, LRUCache, TTLCache"
    end
  end
end
