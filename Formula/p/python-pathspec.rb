class PythonPathspec < Formula
  desc "Utility library for gitignore style pattern matching of file paths"
  homepage "https://github.com/cpburnz/python-pathspec"
  url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
  sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f472abbcc2c95efda95b3095a555243c8ed3170fc8d724fa121289feff0b3f69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76125e4ebfd6d63edfc6c8e0b407c5942fb883195a9b71042acd1068b3e17daf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1baed96f328f215d1f5b47def846b1e50c5ff32fc8343cbac9c792e32d1ab9ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4a5192129d8ae5d15036ae992f2750853a1221e45b2061dff1106b0592664e3"
    sha256 cellar: :any_skip_relocation, ventura:        "495813231e4f77e9e3d73e1250b5f06ade829d0bc839b803460f232fcaebb62d"
    sha256 cellar: :any_skip_relocation, monterey:       "358504d6bee290dc72cfba04bdfaab7af07abf17ba30698746e0b3cd35c9f70a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0977484c52467327e1bee8b1a3f7dd282722ece4a899f708217e63b303551e40"
  end

  depends_on "python-flit-core" => :build
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
      system python_exe, "-c", "import pathspec"
    end
  end
end
