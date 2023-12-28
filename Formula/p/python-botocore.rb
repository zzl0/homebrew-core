class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/8c/bd/0068ae84de8a3d95584a220cae5e84fefeec52371112d623369d40a7306b/botocore-1.34.9.tar.gz"
  sha256 "2cf43fa5b5438a95fc466c700f3098228b45df38e311103488554b2334b42ee3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d13d4e141cec4ae3bb5a2eb911807b20194315c4be3715a70be7e5b11cb11c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb5525e0ddc50328758afeac13555dc1a47f95800a073846711f19b835acde1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad1ee85f83b2265124aa241571f3639c1805852b10d77e85906d1d854ce45c52"
    sha256 cellar: :any_skip_relocation, sonoma:         "281fe88ad96c36b7026732db232ec9a1df18538c7613e700b7361e2ccacc8c3d"
    sha256 cellar: :any_skip_relocation, ventura:        "1c1ee68387772e67c0de965aa930b8908d2282e7940cfb0f31c9be5ead661fd5"
    sha256 cellar: :any_skip_relocation, monterey:       "1cf79834f0a87d892482858b4fc22108cf3b63cfaa2f1d3c88672933c96a7ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f131b1674588e27e05c710432bcb526b3aa46fffa77d12fb93197f30e56f719"
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
