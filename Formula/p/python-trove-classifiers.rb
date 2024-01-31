class PythonTroveClassifiers < Formula
  desc "Canonical source for classifiers on PyPI"
  homepage "https://github.com/pypa/trove-classifiers"
  url "https://files.pythonhosted.org/packages/c2/d3/2c793df6cea96eda294daa400e4b6f06cd75b7a65005eb2c84aae2d08c5c/trove-classifiers-2024.1.31.tar.gz"
  sha256 "bfdfe60bbf64985c524416afb637ecc79c558e0beb4b7f52b0039e01044b0229"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cdc933cf7b0df167488f813ce9cbec39c9dd1f59e2a228fa21828e008e3e75df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fff2396a4612ba16493ef427b96b0e7b14ee2dcf637b021bd17a55dd66fa66f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a05b68616501236d01ab75e854d89943ffa2d4aef5dd733321ffbc50fc2958f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ebd0259c237d757589cdbdd6c89402ccbb0392341248e72a38d5fdae1b987ad"
    sha256 cellar: :any_skip_relocation, ventura:        "291c8c7cab59bad962202ce19ff3d4a8cb5b1a0488f0624e836b49b9564b05a7"
    sha256 cellar: :any_skip_relocation, monterey:       "77781cd4d5945e3fac28084c6d0db5e6be68cb32104b308850893049ca612851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2db900df8a44854ff967fd9d682e1645b262d0bbe5beee65062f964d05c80c4"
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
