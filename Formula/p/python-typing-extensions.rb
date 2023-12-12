class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/1f/7a/8b94bb016069caa12fc9f587b28080ac33b4fbb8ca369b98bc0a4828543e/typing_extensions-4.8.0.tar.gz"
  sha256 "df8e4339e9cb77357558cbdbceca33c303714cf861d1eef15e1070055ae8b7ef"
  license "Python-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb23d0644b58f54c53b29bcfa972fc1df5a0deb0626741a9c558e4ff9bdee613"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce92e1f123de4780760d2364f4ce025aa1d04db0102e48482d2f3dd15ae8505f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d1a56431c1c91b55a80cb25bc7d8cb8a9ab4ce8411fba4602078e0276a9db3"
    sha256 cellar: :any_skip_relocation, sonoma:         "460177bfac2b4730891d396b489a3d303b3d725b11c954241288e301d0014bb3"
    sha256 cellar: :any_skip_relocation, ventura:        "a786f8d064f78f0773328fee9921ffabeb7f07f4831858680ed910dd826f6975"
    sha256 cellar: :any_skip_relocation, monterey:       "1744a216b8ed8693adb8e9c17c1536b96eb8ee3ff8f4aa23a49d703fcf86b0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf1629102c71af4127df318ce60a3fcc4eda13d74c34013d860818046c6a5b4"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "mypy" => :test

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    pythons.each do |python|
      system python.opt_libexec/"bin/pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `typing_extensions` module for Python #{python_versions}.
      If you need `typing_extensions` for a different version of Python, use pip.
    EOS
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", <<~EOS
        import typing_extensions
      EOS
    end

    (testpath/"test.py").write <<~EOS
      import typing_extensions

      class Movie(typing_extensions.TypedDict):
          title: str
          year: typing_extensions.NotRequired[int]

      m = Movie(title="Grease")
    EOS
    system "mypy", testpath/"test.py"
  end
end
