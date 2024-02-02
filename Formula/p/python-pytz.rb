class PythonPytz < Formula
  desc "Python library for cross platform timezone"
  homepage "https://pythonhosted.org/pytz/"
  url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
  sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fb1d4514ffb1f049ec0a240f1889bead2da6ba68066f23e0c1c2b4df9bcd408"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "870fbfab7844a62dfe277b8f3d1ab7dbdb1b7659f755968426c33e5e5d9521a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6441375d8c36b2a6bbdd03b4f04c282e3a526616995bcf0149769b72b20babfa"
    sha256 cellar: :any_skip_relocation, sonoma:         "a18ca7e5a0cb28c51fb21c9027e79282334903d64c92a0f1c85639a818fdb7d9"
    sha256 cellar: :any_skip_relocation, ventura:        "cbcb3cf7a3cc2aba0c295e3f4491b3766d5d69b0ac9205fe52313fb47d3f1750"
    sha256 cellar: :any_skip_relocation, monterey:       "b59f47083defe07488974eeeebe541c353e791bda58d15dbf36dfedc76afa679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8b174b29bc4e7a1abf88cbeae252ea5cdb86267dbb6ab62c9fccc57a4f7504"
  end

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
      system python_exe, "-c", "import pytz; print(pytz.timezone('UTC'))"
    end
  end
end
