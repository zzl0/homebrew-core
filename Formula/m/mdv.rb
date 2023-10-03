class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd476bd5efe39d03d9d8e8caba7c759ceabd278e95f289ed214d188a17336c38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86c5e40583cfc1ef7eb3c6d7018c583fc6f4367ffdb17b5cfcc0fa56243e880c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9142eb09dfabac520788ef54edd381ef502a212f17ef19b60d44fe3dd0043703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "821062b5e21a8a9f40a436f8c519f79f37cb388b8b18a328122627ee2deeba77"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b0d2ffe60e8e22d632e0b6340b56c275ecd31ea0c038f014590408f7ae8e42c"
    sha256 cellar: :any_skip_relocation, ventura:        "cf6c06afc79b496389ab63a5dc889247db69d3cf989e0c84d053e628d6fe4937"
    sha256 cellar: :any_skip_relocation, monterey:       "56998e7ede36db96d375024160d0395a145e6eb4e505aba865d0150f086d41de"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e481631fad73db799d6aefd0e76ae504f30d4723dc13c83da4e079ccf417c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98aaa2c71d47a881ab002a879b421de18fb023efc9452262f8d9b396414a064a"
  end

  depends_on "pygments"
  depends_on "python-markdown"
  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<~EOS
      # Header 1
      ## Header 2
      ### Header 3
    EOS
    system "#{bin}/mdv", "#{testpath}/test.md"
  end
end
