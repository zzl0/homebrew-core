class PythonIdna < Formula
  desc "Internationalized Domain Names in Applications (IDNA)"
  homepage "https://github.com/kjd/idna"
  url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
  sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8539307f91bfcb96c0bd44501a6b1479b3572b5f6c8d9b660a4efe5a129b6ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8112da98633ad2b2a49e1760aea71633c480807a86cca32c8d5d75e22af8fd38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a048755f0b098b2a5fbc98ac9d9126813b8d2711c3ba4ff981006d8659b84611"
    sha256 cellar: :any_skip_relocation, sonoma:         "b30d80debc84a704620694f927d87cbb8372c2a1ee57a2fb6a8c2b3c49de3d64"
    sha256 cellar: :any_skip_relocation, ventura:        "b12e35431360154d03a87b63096191f1e3c85db1dcdec9535b19945eb8c4f87a"
    sha256 cellar: :any_skip_relocation, monterey:       "aaa2e7b70adee0e3f66ecc37d1008329dc3c337bf6276099c59d185f1bef43ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36e286da3fcdd019a670c45881b41541013f769e71a811874ffbf3eb302a2121"
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
      system python_exe, "-c", "import idna"
    end
  end
end
