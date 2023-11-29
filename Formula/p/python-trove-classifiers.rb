class PythonTroveClassifiers < Formula
  desc "Canonical source for classifiers on PyPI"
  homepage "https://github.com/pypa/trove-classifiers"
  url "https://files.pythonhosted.org/packages/3d/14/fe9a127564317f1670d1dd2e2e74b9e09fc157563aa2ffbe7d113d004c7a/trove-classifiers-2023.11.29.tar.gz"
  sha256 "ff8f7fd82c7932113b46e7ef6742c70091cc63640c8c65db00d91f2e940b9514"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e197c4ea2d9c19dcee91b338136a4c4f3287cfde5ca0fa14b35acfc950e255a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b5b238deb90f2f237854d0106366b0269891cd6e5da0a7cb139b5546dbc52e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f7909c1f3a1093cc52387e22aa61145bfcd0011537172920942c8bd96f4de8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0227826895a8595e385e29c3eccd07fd19266be82f50bff9775bd75998476655"
    sha256 cellar: :any_skip_relocation, ventura:        "6c3de9f3d011d3c69c42e98bb380f33a0e26faffc51e8b61a73a9c2d2f36d110"
    sha256 cellar: :any_skip_relocation, monterey:       "c9176d06c313d5902a7005a3629773b0de613b49a3576046490ba4a086425d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5731161e6af909c7d9a9641b65dfea09f059d8d0b85c569e8f6f6b80ffef160c"
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
      classifiers = shell_output("#{python_exe} -m trove_classifiers")
      assert_match "Environment :: MacOS X", classifiers
    end
  end
end
