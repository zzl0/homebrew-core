class Pygments < Formula
  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/11/a0/7e8158246de1f7062a9a01963503d83dc64a6d1d6b2e3aa2e46e92b94314/Pygments-2.16.0.tar.gz"
  sha256 "4f6df32f21dca07a54a0a130bda9a25d2241e9e0a206841d061c85a60cc96145"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22dd62a13b5fa28d0b13af36ac5c065d54671946c8a04e25c9da8c3f5dab0c1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cf29db56c6db4b94612f46c8c6901faeda2d6638e620eda8a54c42f83088701"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35f8b8852d8ddde37570525f201edad241dbb0f35a323ef4761de0722a47942f"
    sha256 cellar: :any_skip_relocation, ventura:        "f5f47a58e80f27048a3ad496eeace812d50b73fbe570059efab7e8b68feb81e9"
    sha256 cellar: :any_skip_relocation, monterey:       "c60a1549d0f8ac1af0130f98982c987d13ba3ca499d90243f03cbe5011da8f6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eadfd8db2188556b8c8afcc580a8dd767bba6e44e6908c940e42f72798c514c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a0407703d117068c5fde3fb7bc7633e3cbb3b023fd662f5742c2939db97eaa7"
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
