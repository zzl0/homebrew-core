class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/91/43/4121cf96ed3a2d68d862663552d8044e1d987d716b6a065ab53cd4d4640f/setuptools-69.0.0.tar.gz"
  sha256 "4c65d4f7891e5b046e9146913b87098144de2ca2128fbc10135b8556a6ddd946"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab5ed58750bdff8db8d76e3069eaf7467511533c23605b8b2180bdc98cb6c2eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c80c719d0cac378612f18bd73bd8f7f111fffe60888d242166a388b44b6cafcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4beec527bdd2c3f8a4d98d38af4b540121e647cad85fda360e8352e266ec0d91"
    sha256 cellar: :any_skip_relocation, sonoma:         "627f7a6f95ed01623f37fd3e312a064000deb59f65ddf5afe4464bba329bfe9d"
    sha256 cellar: :any_skip_relocation, ventura:        "665042c29e5cfc33ca8b61e688a7cb8e56614e25c83a46bb6e48db92947eaa91"
    sha256 cellar: :any_skip_relocation, monterey:       "b7b75791311c7c8828a6a413fee26023ad49a0c06c77de586da6b8fa22a58fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06a95823fc00225cdf94739d478b2a4bbb687f59f77d42166998bebd53c45972"
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
