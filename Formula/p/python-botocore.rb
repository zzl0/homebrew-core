class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/de/54/f244644bded1ef26ab7e8170416fa0a4149a509c56b36121e9137d1b9d2c/botocore-1.34.13.tar.gz"
  sha256 "1680b0e0633a546b8d54d1bbd5154e30bb1044d0496e0df7cfd24a383e10b0d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "246237c6ac2a6a05bb44615c066de2835322e6488c2074facb7ce9aecc76fe9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40c6d0ceb147419dc1a7cd22e9f8967342d8dec3cba2470fe3ac36b0e803ecd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "585f4ebf5e88293cf826d2e3c7325dd2576b6300a80aa4c87509d2523659dae5"
    sha256 cellar: :any_skip_relocation, sonoma:         "726f512b67f41afce8f7cdde41a32d6930753938dcf936d7d4a27a3815722c55"
    sha256 cellar: :any_skip_relocation, ventura:        "8742eba80422568e4b2b274468d882eccc8136a696f3f8c758edc38897adc1d2"
    sha256 cellar: :any_skip_relocation, monterey:       "2b8964b75006ec33e90dc2d16cc646748887985df88a755347ec4abbbc17589c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd6d93faeb82777b45cc2ca4fc0f877eb5530f656d228231f7b661b32b3db55"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-dateutil"
  depends_on "python-jmespath"
  depends_on "python-urllib3"
  depends_on "six"

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
      system python_exe, "-c", "from botocore.config import Config"
    end
  end
end
