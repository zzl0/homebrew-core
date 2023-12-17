class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/releases/download/v2.8.11/opendetex-2.8.11.tar.bz2"
  sha256 "f5771afc607134f65d502d733552cbc79ef06eee44601ae8077b79d852daa05f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a046f41d5f06e58bd4424b1c44fe9aad39a5e716dd39f4205be6cb5419bf3b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e8d3d426c7d1f17c8939d089385d2bfe34ffc413f9972460db1d718b36ee49c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "492e3ac4f09d8ec46842f3c9a76ebe7e1c750c8872a7349513b5b6274fb5b726"
    sha256 cellar: :any_skip_relocation, sonoma:         "60a8f762f9fb9cbd7fe0036daec56fab0ed9713efb1c251e805ca2cf692e7029"
    sha256 cellar: :any_skip_relocation, ventura:        "d63d41beb9c3f2e2b16e815593b12e6bd23f2b495df93423a33af28c98b6e0b0"
    sha256 cellar: :any_skip_relocation, monterey:       "8ae1595f01817366f9abd99559ae95d6e70b90ba88ec5ef0f6973b9f3dc8c3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ee8f83764d07fdb0ff7cc7795251aeb694ffce8ebeabadbd52514ce980f6566"
  end

  uses_from_macos "flex" => :build

  def install
    system "make"
    bin.install "detex"
    bin.install "delatex"
    man1.install "detex.1"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Simple \\emph{text}.
      \\end{document}
    EOS

    output = shell_output("#{bin}/detex test.tex")
    assert_equal "Simple text.\n", output
  end
end
