class PythonBoto3 < Formula
  desc "AWS SDK for Python"
  homepage "https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/index.html"
  url "https://files.pythonhosted.org/packages/07/2d/6b217bb14849a79d6c419b96518e55252995b9857b1df52b952cbabe066b/boto3-1.29.0.tar.gz"
  sha256 "3e90ea2faa3e9892b9140f857911f9ef0013192a106f50d0ec7b71e8d1afc90a"
  license "Apache-2.0"

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-botocore"
  depends_on "python-s3transfer"

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
      system python_exe, "-c", "import boto3"
    end
  end
end
