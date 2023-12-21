class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/16/22/25fac51008f0a4b2186da0dba3039128bd75d3fab8c07acd3ea5894f95cc/mypy-1.8.0.tar.gz"
  sha256 "6ff8b244d7085a0b425b56d327b480c3b29cafbd2eff27316a004f9a7391ae07"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "133de6c80c128265de7aa97735fa92e8ce0a8fb7111ce2fdc2c619731219c650"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cbc820d6f8945fa464b6aa45a88eb4dea798f47babd8cca6b260025f2cdab83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86c120260cd4f626ee6ad7d1f349f02c1f740da4ef316a307a9f086643c2f439"
    sha256 cellar: :any_skip_relocation, sonoma:         "d15053786877a21d842f3b002042f939fa1b48b192b6fec96dac425a61b78d63"
    sha256 cellar: :any_skip_relocation, ventura:        "ab7a3718247842bbb6a0024cba0424181ddf3423ddee43d0039cdf2c2321722a"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c6fd4adc06c028b2d2ec43f6df45ff3897de9cb8d0998a8cb577638e1242a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d34ba98f52c9a2e53bef6b7eebced46873c2901c0ed8bc15cb2475b46af014"
  end

  depends_on "python@3.12"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
