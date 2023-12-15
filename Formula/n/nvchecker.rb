class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/9c/1a/2dd119c062d5f32789098a23f2d0bc76ff6e3c6195578f91e22a97aec9b1/nvchecker-2.13.tar.gz"
  sha256 "17c69b7f9c13899a49aeccd7c094e88688aa89509d4cedb254d2c7b232879338"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1d6abf66947c36ef620be172cd8531d950e785574f187853b5ba5201c9981ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b215c8739de7b77d460e5b9621ca084d0b603dcee89ab33483d7fb422ab1c7f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb239f66c865aaa1a0bf73ff04eff61fde5322f2510db6e3dfb0a1c3d694b447"
    sha256 cellar: :any_skip_relocation, sonoma:         "92f4c4ac52e991d8fef6e9caf2b2d57d3eaf518bbda345ff3b50280b5db4a7be"
    sha256 cellar: :any_skip_relocation, ventura:        "7675910c53e81945064dae7594d50f37a2fbeac2c9aa4b2704a1f9e6ca3c16f1"
    sha256 cellar: :any_skip_relocation, monterey:       "ffa9fe0ebd5bc5126bc63f90624665857f0f6bef0801915ed156c6d9f8c8edec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06be258da8babd9595f84be864cc23633a0d2405578822604aa7e446a90a78b0"
  end

  depends_on "jq" => :test
  depends_on "python-packaging"
  depends_on "python-pycurl"
  depends_on "python@3.12"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/99/4c/67e8cc235bbeb0a87053739c4c9d0619e3f284730ebdb2b34349488d9e8a/structlog-23.2.0.tar.gz"
    sha256 "334666b94707f89dbc4c81a22a8ccd34449f0201d5b1ee097a030b577fa8c858"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/bd/a2/ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2/tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end
