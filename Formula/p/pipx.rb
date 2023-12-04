class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/fa/0a/cdbfa925343ace5e2f8fbfdac97822efe1da8d89fa2782b56f400560860b/pipx-1.3.3.tar.gz"
  sha256 "6d5474e71e78c28d83570443e5418c56599aa8319a950ccf5984c5cb0a35f0a7"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7be1a6e5af8e42e5e48061b8878d2964cfb22d64eb539a7b16ee1b308d5dda07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3525b052fd23af580d0cd204b1f83676a3c62fabae30a55b9123cf0c1144a5e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df2995d4ab82318fbfa6e2d6eb1b990be1890d0d9b6f5a53eda13141177f49c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb59ee5e8bd44c75e39a15457acb34c31a43460bdb825eb3334e6646bb5e0e38"
    sha256 cellar: :any_skip_relocation, ventura:        "2e291cb47aba172ff517b7832ffded11e8d5dd2b142ef51fcd763d9e88071051"
    sha256 cellar: :any_skip_relocation, monterey:       "a3c3d4c0736f0fa7512db992c428cc8a9ede133b193bd410c939074472b70ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72eef8792c20f9026e581a3df3ea6fc328da415899274aa3f97c2f329673169f"
  end

  depends_on "python-argcomplete"
  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/4d/13/b8c47191994abd86cbdb256146dbd7bbabcaaa991984b720f68ccc857bfc/userpath-1.9.1.tar.gz"
    sha256 "ce8176728d98c914b6401781bf3b23fccd968d1647539c8788c7010375e02796"
  end

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "src/pipx/interpreter.py",
              "DEFAULT_PYTHON = _get_sys_executable()",
              "DEFAULT_PYTHON = '#{python3.opt_libexec/"bin/python"}'"

    virtualenv_install_with_resources

    register_argcomplete = Formula["python-argcomplete"].opt_bin/"register-python-argcomplete"
    generate_completions_from_executable(register_argcomplete, "pipx", shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
