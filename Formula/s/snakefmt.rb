class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/1f/ce/d2dee5da2cf76cdec5a5fb9dc7b99849b08ea28a5dc17830afc2baadaffc/snakefmt-0.10.0.tar.gz"
  sha256 "53eae69fc81425e2192684eba76171bd648b05dcba93c9d5f45746d3fadb8617"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "563bdab3ca70041ef51ac0de484a7f1392902188b9c2f8469f452baefe3a8077"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9044ca40713671663a5e889e7a8901e7b789468a21f2e53c6e5116061369941b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0bc724b659825f8f07344e20b605f9be8c7f7e16d8870a213eecbbcad308842"
    sha256 cellar: :any_skip_relocation, sonoma:         "360c63884a6e4ef6c08d425e34b7f7dda73ca5c3d45eb3e04652473cebf1aae2"
    sha256 cellar: :any_skip_relocation, ventura:        "ca32b14c389ca56dd34b8ac96e4268add3c859b98f68f72e4abf7ada08d45afb"
    sha256 cellar: :any_skip_relocation, monterey:       "de6263cde6dfd9e90064d9c961482904dc55d1b682502168c24a1f0388fe7a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5523781079ba03f5cf4e9bb790eaae2b61bae20c1a3efe6ace3dbcbd9bc94757"
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
