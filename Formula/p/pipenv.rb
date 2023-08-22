class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/0f/d7/15211bfc516d7a8a725df1b546426cc017bda9fa7b73646f12934044ee25/pipenv-2023.8.22.tar.gz"
  sha256 "343e5bd0e726d8cf66bae2d3c8cfc153dfa82f454bc0f7c302014f85e5821512"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c9f3cdf9a6d1e0d28a9da3ed8394fef11762780307d16bf08cf2e4b6c00c1bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0b31e0c046338ebe2c7c0b7a181e35f46862ec3bd617e8a759b90bcbd9f1721"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec2f2af35c7de2e8de4bf614a48e19d3cb3633f505f7e505db8e601854a88300"
    sha256 cellar: :any_skip_relocation, ventura:        "8b9c7a02523b65898b6bfa363855e31d7c757596916896f380662f0aceffe830"
    sha256 cellar: :any_skip_relocation, monterey:       "5e698b9e3c59eee08012284fe0775f5500de98ec3210caad8f2c5004feb2d894"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c9a4f327b39c5bece701fd53164070c730ada2d2140d02289b7fd7d6d413d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "474d4417aea07e0a5d896d7a1b1274bf00891781b443da1eb3d1a13a63876cab"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/77/f9/f6319b17869e66571966060051894d7a6dc77feceb25a9ebb6daee7eed5a/virtualenv-20.24.3.tar.gz"
    sha256 "e5c3b4ce817b0b328af041506a2a299418c98747c4b1e68cb7527e74ced23efc"
  end

  def python3
    "python3.11"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pip", libexec/"bin/virtualenv"
    (bin/"pipenv").write_env_script libexec/"bin/pipenv", PATH: "#{libexec}/tools:${PATH}"

    generate_completions_from_executable(libexec/"bin/pipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "--python", which(python3)
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
