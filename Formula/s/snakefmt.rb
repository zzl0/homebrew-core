class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/e1/ca/ddd0028b2c65850f0e12ed91356a0677221e76ae914fa34382b7336b33a3/snakefmt-0.9.0.tar.gz"
  sha256 "54c78050edead20cea5f87a6c9674ee1b5e4e38faac2852b45d0650faf9cb319"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3762d012f1ff5d90f9d0fc5bcdca2af9beb63efef5f9515f984d71b14a3cdd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8591f076b34234c5c690306d9bf908a27af6b1db11d982b7c313aa71a217a041"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba551a358e1036307bb2e0483fb0a538aac32c44b2c1d750d63fb072891e456"
    sha256 cellar: :any_skip_relocation, sonoma:         "345eeb70933594346c083ae83a1456014b449a4eba7f82db6d5a0139e7dc9e59"
    sha256 cellar: :any_skip_relocation, ventura:        "427de27882498f77865c676ed4b2e0d64d9f107286a9719c0e618d98a93bf548"
    sha256 cellar: :any_skip_relocation, monterey:       "7a41930a69c6c86c412af8f06c98c0507d9212058c3ce927dcaebdc624114ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7458f09d84047d4cc63c44541c8e54115ea789906392dcb9b595b87f8d75d063"
  end

  depends_on "black"
  depends_on "python-toml"
  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    black = Formula["black"].opt_libexec
    (libexec/site_packages/"homebrew-black.pth").write black/site_packages
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end
