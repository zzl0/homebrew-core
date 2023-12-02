class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/da/1b/5ebbf68e321684ffca2ee6757c4f6962a136e75a4925554f774f511666ad/pipx-1.3.0.tar.gz"
  sha256 "db07ec2a3a15d772a71b2608c134f065d7fbc51d4654abe6adfc412800ed6ba4"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c251e061f562598efd8fb642a6fb54d0006f4dda3f303653d7ed3de56934c3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39685c5ea5a709516d11217daf53256a1c65dec3f489047ea22c9815751c05f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b9ccd7f5991fb704e7fe748cebdeea5725c40ba488e3f7135c021ae0b042d56"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2b007633eac75ff0a3d4422774d959ea52f730190d6f63a04c4defb54176a4b"
    sha256 cellar: :any_skip_relocation, ventura:        "51d1c73eac458262a27c2c90dd0b07f68ffb52d53b5d53927c0ca451955632ed"
    sha256 cellar: :any_skip_relocation, monterey:       "ccd050e76a2f9bf90458c17ad50c269e0465f67bb3be26f2dd82638789ae0b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40a91a9140f14d59863121e043c963325a4aee2f03adb50f8b40352a39fa9dd0"
  end

  depends_on "python-argcomplete"
  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/31/28/e40d24d2e2eb23135f8533ad33d582359c7825623b1e022f9d460def7c05/platformdirs-4.0.0.tar.gz"
    sha256 "cb633b2bcf10c51af60beb0ab06d2f1d69064b43abf4c185ca6b28865f3f9731"
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
