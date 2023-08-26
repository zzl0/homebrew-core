class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/35/0e/564c71fe3cdf59a4acaaccaea354d066e5d9044eba564dac070bb2075432/pre_commit-3.3.3.tar.gz"
  sha256 "a2256f489cd913d575c145132ae196fe335da32d91a8294b7afe6622335dd023"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cf1efa72e160a23d5e0592db41eadb32fa6db7b2bfc5b95271f8fa4b1431fa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f43e7263f19791f71836d93273e1051b4b86c15936bf163767ddfb2c3eaf79b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25ba1d395b41675712ba78e8ebeea20a0b091cb25d1f9890a932f881c7b6350f"
    sha256 cellar: :any_skip_relocation, ventura:        "071184e02050a11f95a4b934ec186dbb76a2c90d2aaa84e4d9cf727af8141680"
    sha256 cellar: :any_skip_relocation, monterey:       "df34077a7281f0b72c4de10ab6a6a809ac2c101cfb2609bc341014a5bf77ea2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ed806733865fa97054063e374eda498c8136a73de28d9f80c739de55eeae816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369a9f80e192432c8f15351c59b0b0a47816f3a1ad45e06b81e9999ad68f4119"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/e0/7e/dc9ae38e2944611174051371e62cb79a9fd98fd8b4e4f07d0c1fbf2bb260/identify-2.5.27.tar.gz"
    sha256 "287b75b04a0e22d727bc9a41f0d4f3c1bcada97490fa6eabb5b28f0e9097e733"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/48/92/8e83a37d3f4e73c157f9fcf9fb98ca39bd94701a469dc093b34dca31df65/nodeenv-1.8.0.tar.gz"
    sha256 "d51e0c37e64fbf47d017feac3145cdbb58836d7eee8c6f6d3b6880c5456227d2"
  end

  def python3
    "python3.11"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.11"].opt_bin/python3
    dirs_to_fix = [libexec/"lib/python#{xy}"]
    dirs_to_fix << (libexec/"bin") if OS.linux?
    dirs_to_fix.each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        realpath = f.realpath
        rm f
        ln_s realpath, f
      end
    end
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~EOS
      repos:
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end
