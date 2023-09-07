class Pympress < Formula
  include Language::Python::Virtualenv

  desc "Simple and powerful dual-screen PDF reader designed for presentations"
  homepage "https://github.com/Cimbali/pympress/"
  url "https://files.pythonhosted.org/packages/17/65/ffd6b30dae047fab0d4b1bef14940f194f555e9b7b6fe1520a650233e6ca/pympress-1.8.4.tar.gz"
  sha256 "ddc9c21c6a0a517d204f3231d6484cf9bafac7dfa0f565e1dbc48b866f7d78de"
  license "GPL-2.0-or-later"
  head "https://github.com/Cimbali/pympress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "271f2deb743361d30104a8bd212b89a003396d29c0a62f9c87f7162061cee5a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc68c5f47c42a0615da03a20e189f27db0a36c189e328947d8b3b1f0de8dd432"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20a8f86bd1eebbb5b0f819c06106200ed98a15adb1523fa101edc9f9a83c0eca"
    sha256 cellar: :any_skip_relocation, ventura:        "497de69911b227fa982c1ca762819364c805770332811bd14a094c8126d1c916"
    sha256 cellar: :any_skip_relocation, monterey:       "e37c1a1d8f97207618d24469d7001e4b59e1bf8f423ffe79ad062d129e51742d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca76312ef16c5ef9bb6a89bcb8859bda35c81e08b63163162367c35b35db8a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "821ab3272ad9db45fb1da5a775f7d0512a22df8e777804d678e144ad3ebe18d5"
  end

  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libyaml"
  depends_on "poppler"
  depends_on "pygobject3"
  depends_on "python@3.11"

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/pympress"
  end

  test do
    # (pympress:48790): Gtk-WARNING **: 13:03:37.080: cannot open display
    ENV["PYMPRESS_HEADLESS_TEST"]="1" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"pympress", "--quit"

    # Check everything ran fine at least until reporting the version string in the log file
    # which means all dependencies got loaded OK. Do not check actual version numbers as it breaks --HEAD tests.
    log = if OS.linux?
      Pathname.new(ENV["XDG_CACHE_HOME"] || (testpath/".cache"))/"pympress.log"
    else
      testpath/"Library/Logs/pympress.log"
    end
    assert_predicate log, :exist?
    assert_match "INFO:pympress.app:Pympress:", log.read
  end
end
