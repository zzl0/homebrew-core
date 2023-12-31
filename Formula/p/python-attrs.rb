class PythonAttrs < Formula
  desc "Python Classes Without Boilerplate"
  homepage "https://www.attrs.org/en/stable/"
  url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
  sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6844a7561b272fb626bd4b5ae3c9dc1180910c6cbf8e79c7ebc47750c013e6bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0684087668cab4e80124d76940cdc9310fc8d9eb56385fd0c474d562818a2a4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fe7531e7461371c350fd2943897683a00e81de9acf270b1de8da79635a7ab95"
    sha256 cellar: :any_skip_relocation, sonoma:         "c54b7d784d133ae087023faf9d880876e32a113061eb73bfaf3151148d904438"
    sha256 cellar: :any_skip_relocation, ventura:        "11ff19ec88c748184808c3864bbc5d9fdf38f1de1b593fc6da88aaa7cfec0c2c"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d0670d008fdc3488f98993e4e6618e1787a2d71d7d72e0bf0d42f52bd1db12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f14767f27fd3dd603082b09f9a36a85982f468825172ec4121c25242372d40"
  end

  depends_on "python-hatch-fancy-pypi-readme" => :build
  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
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
      system python_exe, "-c", "import attrs"
    end
  end
end
