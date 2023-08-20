class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/a1/e4/456ff34fd6bbdd7695a8b5b06f5b2370ab000ee3f07c33ff8d13e1e0f659/vulture-2.9.tar.gz"
  sha256 "0f4d86ba515e67db2860539894edb4e387b25696f831234826dd72c636f0331f"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28808ad1470a0e3cadfcb63cf68c82921e6fda0c04789454890428b314cfcd89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cabacd95b9c2e0bac4a37b4459bf310363a0b169dab7553aa3abf2368b5a8785"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8eb7af91c80458509ff157b57f50d0297d638b14979878664257d53c5135e57"
    sha256 cellar: :any_skip_relocation, ventura:        "225a367c4a920558f7b33772c5ef35aab23bedb44dffcd42870746794d97100d"
    sha256 cellar: :any_skip_relocation, monterey:       "3e20bcd278282381534e85376fb858417953066f78d1f05e9e9c7357075c53d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6e8de8bb8050d860550b864a0ff6795ca2b34d25ae5e244dc47c4da768055ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef1619b88935c28ab2eb778554513f85b83da6df870fe52a43aaf08be202d5fc"
  end

  depends_on "python-toml"
  depends_on "python@3.11"

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # upstream bug, https://github.com/jendrikseipp/vulture/issues/321
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version", 2)

    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 3)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end
