class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/4b/d9/d0cf66484b7e28a9c42db7e3929caed46f8b80478cd8c9bd38b7be059150/setuptools-69.0.2.tar.gz"
  sha256 "735896e78a4742605974de002ac60562d286fa8051a7e2299445e8e8fbb01aa6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4ede45357f92bc96d19c99841240bbb82d8a843eed16835dec6e01fff028770"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f00585f557169c6173333166ca107daa30b7f6673170b5db91c22a7193c449a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aef3415dc795966b2d8095299210aca5969dc05faa925996da5618b42e2bfa0"
    sha256 cellar: :any_skip_relocation, sonoma:         "99f4e6b07e2db89bb98cd77f836a9289c7f697065d3a275e1c0517b76c6761f8"
    sha256 cellar: :any_skip_relocation, ventura:        "30fb1eb3bd556cb190327305170064f0c8cfa767d539642d37a59c37dc7c4fb1"
    sha256 cellar: :any_skip_relocation, monterey:       "73667bff109382ba6b959aeefd67c646469a1b29ce06398b9ece852fb828377d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee67b82a63f559c073b0fd85678dc9bdfb67ff8f4dc306c29d859be206c58261"
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
