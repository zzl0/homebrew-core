class Pygments < Formula
  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/22/04/097cdb7d5c6faee58e31a8a2b63cba2222a52066f734b3fdc713c6f40575/pygments-2.17.1.tar.gz"
  sha256 "e45a0e74bf9c530f564ca81b8952343be986a29f6afe7f5ad95c5f06b7bdf5e8"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcdcb0e1cd2635e85238f3630d46d6d840268fcf159eba9ca6966287a9c097d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8d133cc5758c503d6abf867313fed19744bdb8a316a480b6ed5676a831e84a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d812e013863e13ec73328e45ad0a7b7afc78c543b11f652ab14d882c92129bbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3737fda611f9908e5193812bc4fb54a6f1f1019fdf02e08b756d27d99699e5d"
    sha256 cellar: :any_skip_relocation, ventura:        "2606b39269af6cf5f987c40fc930e87215a26255ef94ffe4f9bada75e5a6272e"
    sha256 cellar: :any_skip_relocation, monterey:       "9e62e95d356fe236111425978acd7157a99e6e8e78ca4e6fc7b49b5f3911105c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fb6e852a1b817a626ac252c76fe3e53ce997a46b5bb1e58368a2d4e1a01bff3"
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
