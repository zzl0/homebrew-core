class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/fc/c9/b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7/setuptools-69.0.3.tar.gz"
  sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "422411b81400ef2ccabaf444da4e08d8c7e4cf2b15300c1840e0c362b36ffdb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d48d89585de306ccf804d60bee0d968a3a39cc68957cfe7b9cb6d0a4e11b37ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e02ab02e6ae808b561085b2149b8eb037086179b32ebf1c7ba099fab282c481"
    sha256 cellar: :any_skip_relocation, sonoma:         "57c4023c78823c72db7e4701c2f942ea380e0ade386eb84c5c4bc6e15b2adc8b"
    sha256 cellar: :any_skip_relocation, ventura:        "d2771b32e2303a373e949c92aac3f0449634aecd27ce1cd97a1bef2830fe3da9"
    sha256 cellar: :any_skip_relocation, monterey:       "f5305c297ebbe7d09431df85006440c7a87b693edad36767002a47cb25e468ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07a6bd6690adcdb4c9fe8102ae5955cf1f5354002f6d53da4521c69929ddb6a0"
  end

  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end
