class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https://github.com/lxml/lxml"
  url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
  sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f11914ad18c6d0325fc94b969f28c47f25be5daae09add83cdd015755fa40aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5ecaa88135b57e035c32b2c6ba09dd9a5e96ee810778506f37e56b3aa06a8a1"
    sha256 cellar: :any,                 arm64_monterey: "841ac4966b3e3d7bda362c190d56018b73488d9ad3b4e13c94899e85d4c6552e"
    sha256 cellar: :any_skip_relocation, sonoma:         "40f6a7499a60d8ecc3c757d43d13a5a92e87ba689ae7c609684a0fe066e3a6a5"
    sha256 cellar: :any_skip_relocation, ventura:        "995322d8ddf590cc47f81e8c2809772f958f277571fa18b9a6957d4182cfc174"
    sha256 cellar: :any,                 monterey:       "3cdda375643985282932cc1f0155855b50c09138ef2c0cf16c88767fdf25ed0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f724b0ce729e67aba1724ca9c7e14a1110ce6417251a032ea81999702db43b"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

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
      system python_exe, "-c", "import lxml"
    end
  end
end
