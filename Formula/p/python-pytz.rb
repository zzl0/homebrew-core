class PythonPytz < Formula
  desc "Python library for cross platform timezone"
  homepage "https://pythonhosted.org/pytz/"
  url "https://files.pythonhosted.org/packages/ae/fd/c5bafe60236bc2a464452f916b6a1806257109c8954d6a7d19e5d4fb012f/pytz-2023.4.tar.gz"
  sha256 "31d4583c4ed539cd037956140d695e42c033a19e984bfce9964a3f7d59bc2b40"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11328db7e868519911f0928f622295e370713395f31943e7e701ac9b88ef8b00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9b1f848bc5affb5fd1b9206ca3297cb3da0051a0dfef4ab183a7c2ac81b0660"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceb5bb725d1ea82385c951f3658788322aa2cfeadaba147e9bb7a5ab0ba3c247"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2b255dc677e970a8f73331fc1cc6c943f9674a2550a51986fa53db015eb14b7"
    sha256 cellar: :any_skip_relocation, ventura:        "40d9a011d8bcab7597d5e15ff7a1afbac71554d3e91b139c5303e3228929f3b4"
    sha256 cellar: :any_skip_relocation, monterey:       "da2747c24c8287f690440009c462158a3772fa71766471a6ad5aab4d815bacba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a283d9fddcb286c359e6d7a749b5ffe2cbbae773df8c47f44f0df45ec0dabae"
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
