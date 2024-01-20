class PythonPsutil < Formula
  desc "Cross-platform lib for process and system monitoring in Python"
  homepage "https://github.com/giampaolo/psutil"
  url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
  sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "557fb8ab221e002a6900878e126d44de629aecab3a85a311bf20a960d949e908"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61c174e3f63ea586370baa91f23e321febef03b0bd9815fd1a229f0d3c749ac9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73beed3597a9cae9aa60d760f4e10f3623f14a22d26a4e678e44126945eaa899"
    sha256 cellar: :any_skip_relocation, sonoma:         "f91c41b98684b687468c144b6777d948c96a2a4c41dfbee2b40f58237790c9ca"
    sha256 cellar: :any_skip_relocation, ventura:        "bc62aa8a096c90fd4d2add78ec5b0ae5844991021cd3190f5c3e29fd75463463"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a4a47eb4bac444c1012a16a69b87a9eec09b63319b0eee8dec1e38ad71952a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b346a8937f133825f7672049d818f09365485abd57a95748e6d00b9d38e099f"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import psutil"
    end
  end
end
