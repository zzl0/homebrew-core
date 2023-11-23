class PythonRich < Formula
  desc "Render rich text, tables, progress bars, syntax highlighting, markdown"
  homepage "https://rich.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
  sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  license "MIT"

  depends_on "poetry" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    site_packages = Language::Python.site_packages("python3.12")
    ENV.prepend_path "PYTHONPATH", Formula["poetry"].opt_libexec/site_packages

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from rich import print"
    end
  end
end
