class PythonXlsxwriter < Formula
  desc "Python module for creating Excel XLSX files"
  homepage "https://xlsxwriter.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/2b/a3/dd02e3559b2c785d2357c3752cc191d750a280ff3cb02fa7c2a8f87523c3/XlsxWriter-3.1.9.tar.gz"
  sha256 "de810bf328c6a4550f4ffd6b0b34972aeb7ffcf40f3d285a0413734f9b63a929"
  license "BSD-2-Clause"

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

    bin.install_symlink "vba_extract.py" => "vba_extract"
  end

  def caveats
    <<~EOS
      To run `vba_extract`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    resource "homebrew-test_file" do
      url "https://github.com/jmcnamara/XlsxWriter/raw/47afb63a79bb89a2c291c982cd9301e10d0be214/xlsxwriter/test/comparison/xlsx_files/macro01.xlsm"
      sha256 "09c35d1580eb6d7e678ba8249cdd1cbc0bd245fbb0eed8794981728715944736"
    end

    testpath.install resource("homebrew-test_file")

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import xlsxwriter"
    end

    assert_match "Extracted: vbaProject.bin", shell_output("#{bin}/vba_extract macro01.xlsm")
    assert_predicate testpath/"vbaProject.bin", :exist?
  end
end
