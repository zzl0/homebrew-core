class Pygments < Formula
  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/22/04/097cdb7d5c6faee58e31a8a2b63cba2222a52066f734b3fdc713c6f40575/pygments-2.17.1.tar.gz"
  sha256 "e45a0e74bf9c530f564ca81b8952343be986a29f6afe7f5ad95c5f06b7bdf5e8"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e68fc0b5c183c8d70ae822c4c43fb23c96b83597f09441deec159201115099f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18c118140c32d49d43069cea65725815e54252394030ebf7659f5524730b74a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "823504e873f31ed10c71fb5f24c2b43f29598770d5229c3d8cdaa4714dd2f47d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7651e791931dfa84769c4e96c8127b37f705413e825af9f823fb3ab3ecdb658a"
    sha256 cellar: :any_skip_relocation, ventura:        "a132cfca099a65700f635bc0cf883d050d47c19b65fc62f58bb363c0e2d2317d"
    sha256 cellar: :any_skip_relocation, monterey:       "b2415f42c9fd536c2cfd30a43b778d02273a613ab06c963be626581b09be827f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d21d474ed493f0d9a5c373a51eecb677bc6ea75f864bc6744dd806923739fbcd"
  end

  depends_on "python-hatchling" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  # Fix package name: https://github.com/pygments/pygments/pull/2593
  patch do
    url "https://github.com/pygments/pygments/commit/cdd61b1ce73f389dbfb4f743422b468c43b41f93.patch?full_index=1"
    sha256 "d6a2c4d3f83da065f2694e55c648207337029ae6b6490c477059df12c4f14003"
  end

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
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
