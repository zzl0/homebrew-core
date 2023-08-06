class Pygments < Formula
  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/11/a0/7e8158246de1f7062a9a01963503d83dc64a6d1d6b2e3aa2e46e92b94314/Pygments-2.16.0.tar.gz"
  sha256 "4f6df32f21dca07a54a0a130bda9a25d2241e9e0a206841d061c85a60cc96145"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99fa2c86e532f8347f5485dbf66a801c7237bc4f7153a69dbd8176cc20d1c409"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38b194f6f6fa8d06bf8d24fd2851afc47334f541c429e9d4c37e79e366799b9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddc5f7c765dd58f4b5678f4a22bbb28e5bb560f281b62403017a1884c60725f8"
    sha256 cellar: :any_skip_relocation, ventura:        "151ce86f8286c1ec94fee0d97126546d24416c0c86c8a828de682bda2d15169e"
    sha256 cellar: :any_skip_relocation, monterey:       "8c7b5a1e7ca890a9897f7dd9309f6bd435e19fac64e17339ed023919086125ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "54e04d811cb5706eb90baaad6cc7f33b4ece4cc9288141e7b6cf418d6c78dfda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e9299d59924f27837184c02814fb963d112112dbfd29d59475a2c9f4870f40f"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  def pythons
    deps.select { |dep| dep.name.start_with?("python") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install bin/"pygmentize" => "pygmentize-#{pyversion}"

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "pygmentize-#{pyversion}" => "pygmentize"
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
      print(os.getcwd())
    EOS

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)

      system bin/"pygmentize-#{pyversion}", "-f", "html", "-o", "test.html", testpath/"test.py"
      assert_predicate testpath/"test.html", :exist?

      (testpath/"test.html").unlink

      next if python != pythons.max_by(&:version)

      system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
      assert_predicate testpath/"test.html", :exist?
    end
  end
end
