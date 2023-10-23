class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/8d/e9/f4550b3af1b5c71d42913430d325ca270ace65896bfd8ba04472566709cc/virtualenv-20.24.6.tar.gz"
  sha256 "02ece4f56fbf939dbbc33c0715159951d6bf14aaf5457b092e4548e1382455af"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "084255bb80300bc4d963ce17a530bf24c289bfb0306dbb81ff3af36c0c018ddd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff65ef186573fd2d156f24557f7131a14daa7ede7b58afb2c71ed51a4c71b84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0c76b544642b1d4589462344aa3ea9b0bd32d395e067ea724acdcdad22af3f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89c902d3103179f1b84d44f3808c909ace8edc70cd20eb5a67f74e4174962543"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e9e6c9f3f485b2d678d9e408f1c6705d4d72d0bb3bd4a865bcd0c1138be0e65"
    sha256 cellar: :any_skip_relocation, ventura:        "1d2b98a0690ce11da73a5ae3899ef7b1b7840733c16b693d7d1f014e1daf6e43"
    sha256 cellar: :any_skip_relocation, monterey:       "469707a1251b5d9b4a0202977af373e6157e424f43deb29a4e40de7b0df4725c"
    sha256 cellar: :any_skip_relocation, big_sur:        "114b76eeee87b96e008af185a48313715c9299de20603dcab59b3e240d73f352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b455b0bac69560a68724f797934d176ba9b75e274602a7b2b6588b0c482a16a8"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
