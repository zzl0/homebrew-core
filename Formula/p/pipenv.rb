class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/b7/bb/95ad114eb5aa85bfb77eb7b0d65e3bb5c52a4a12c7ca8788083b6e73c515/pipenv-2023.10.3.tar.gz"
  sha256 "a07ad06655336a5d0f7c065f1dbc43d1b4c274762020c7bef18db1c694fc2637"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3066a9b67c96011ec36498f020a39f85aff9072d53f25016267bc2c733b97920"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66ec647af668f72afd9d4c61a8b879305ef9de2d22c952a18d1bd461b3bce014"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5a49f7f3928a0316611f3ac14f16084aef3f2112d5f2baff8cf63abe91c14a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84eee54bea5bf8af6a7ecd8b33f9f56e0cf9269b18afd6a105089db2b2cee4c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "88379da6643b7291f101861ac38355e19a86688f174a70a8ccbb0826cf42abf6"
    sha256 cellar: :any_skip_relocation, ventura:        "3f791d8e77723d287db8633e7a8cfc66eeaa527edb3f3bb0e2f4d224ca082176"
    sha256 cellar: :any_skip_relocation, monterey:       "f615b733b915beeb891c20b83ccaf57608e4534b48beac80caf853bc065b68df"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae1c16fc3d7f9eb2bb812db82b0a9cb613ead50ed2774ba69dc65ada9fbdfb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9206508be3eb026812550e9168c30783b4adc72d923470f6c64fa6fd145a63c2"
  end

  depends_on "python-certifi"
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

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d3/50/fa955bbda25c0f01297843be105f9d022f461423e69a6ab487ed6cabf75d/virtualenv-20.24.5.tar.gz"
    sha256 "e8361967f6da6fbdf1426483bfe9fca8287c242ac0bc30429905721cefbff752"
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
