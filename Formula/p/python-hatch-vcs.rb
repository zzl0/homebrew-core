class PythonHatchVcs < Formula
  desc "Hatch plugin for versioning with your preferred VCS"
  homepage "https://github.com/ofek/hatch-vcs"
  url "https://files.pythonhosted.org/packages/f5/c9/54bb4fa27b4e4a014ef3bb17710cdf692b3aa2cbc7953da885f1bf7e06ea/hatch_vcs-0.4.0.tar.gz"
  sha256 "093810748fe01db0d451fabcf2c1ac2688caefd232d4ede967090b1c1b07d9f7"
  license "MIT"

  depends_on "python-hatchling" => :build
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
      system python_exe, "-c", "import hatch_vcs"
    end
  end
end
