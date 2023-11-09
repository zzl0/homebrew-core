class PythonMako < Formula
  desc "Fast templating language for Python"
  homepage "https://www.makotemplates.org/"
  url "https://files.pythonhosted.org/packages/a9/6e/6b41e654bbdcef90c6b9e7f280bf7cbd756dc2560ce76214f5cdbc4ddab5/Mako-1.3.0.tar.gz"
  sha256 "e3a9d388fd00e87043edbe8792f45880ac0114e9c4adc69f6e9bfb2c55e3b11b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db3ad4257bd6855405b4b4af655e608679d9779483d4466d4cb745cf2f96d63e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d35e9997eaf505d80486e2e83d69320f23dce1cdb7500db03f17d4293ef469e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19efc377dafb079fc297c6e9bdf7539e75f0f4cad46a3fda423ae535799f81cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "87b5664fc7896fcb5554f1df5c85e8952cb02c50e24ce047eda89d7248711d73"
    sha256 cellar: :any_skip_relocation, ventura:        "abe4e9560bd7586744448b8adec884f4c9a1a920c3f90bd3236f24b95dcf93bf"
    sha256 cellar: :any_skip_relocation, monterey:       "8af351f08874c1c02c8e6e2da60093c99ffb944f641a5f00354dd88ecfad50a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b909b567eb05d19f1a4bd38adaa0eb11447e9e1cb9406cfceae8c212c8ba27f"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-markupsafe"

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
      system python_exe, "-c", "from mako.template import Template"
    end

    (testpath/"test.mako").write <<~EOS
      Hello, ${name}!
    EOS
    output = shell_output("#{bin}/mako-render --var name=Homebrew test.mako")
    assert_equal "Hello, Homebrew!\n", output
  end
end
