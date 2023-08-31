class PythonPsutil < Formula
  desc "Cross-platform lib for process and system monitoring in Python"
  homepage "https://github.com/giampaolo/psutil"
  url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
  sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  license "BSD-3-Clause"

  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => [:build, :test]

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system python3, "-c", "import psutil"
  end
end
