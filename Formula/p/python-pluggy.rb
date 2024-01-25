class PythonPluggy < Formula
  desc "Minimalist production ready plugin system"
  homepage "https://github.com/pytest-dev/pluggy"
  url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
  sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87883f5160fe791dfdd6624355c5fdaf4305ca967ec1245f45568f633e98d5b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "376b3bf5c729e596e2f8f96655283b25aa21dbf82c2b53bdc6c4a9957d333bf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13af6d795edf1c545f4a6e510b7a3017ba2f743ad2bf3f43c7134871dad09c72"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7eb87b3ffce68228dfe49fa02b79a0a83716e294895fd72d9851b365733b0da"
    sha256 cellar: :any_skip_relocation, ventura:        "7d418f4a267357b80566f8f100fbc7b2f7882fcb53a6a0b47b75b3942dfde7de"
    sha256 cellar: :any_skip_relocation, monterey:       "8c7f6d0d4ed4e73b10cf34308833013d90a1ffd225441a85a99bd369afa8d0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1150011c67539979561ec4d34a7ec9c2e26af1aedb2656c0eb267781da82aaf5"
  end

  depends_on "python-setuptools-scm" => :build
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
      system python_exe, "-c", "import pluggy"
    end
  end
end
