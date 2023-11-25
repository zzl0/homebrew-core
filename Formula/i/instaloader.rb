class Instaloader < Formula
  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/53/a0/49ded81d0134be2e1c22ae4706c35b74594ed1844bd1e9af703fd310d562/instaloader-4.10.1.tar.gz"
  sha256 "902cc8b9569ca7437323199c8e55dbdcd15ea5c8e874c7864e84a36dd55f8584"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "909c1e799088e356af0facd3b8c729c731d3a26941033df4f222a076f73927f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca0ea6e8b4a41bbba5d3565e8da1fe9198e7407596d59630e92aacc65968e9ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "258d2a9305a0fd2a4a09287cd592d329374dde3b61a5297c865c12bfe8c227b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "30521b15dc6de62d63b1f610c5dea963bc693e7aa655290271b530705aa4112d"
    sha256 cellar: :any_skip_relocation, ventura:        "9e4c1a0d000e520deb4d94fbcfb2d10b396ec4d7652dd8ab187657c6ec9a5c23"
    sha256 cellar: :any_skip_relocation, monterey:       "9b63de85a215038ef13fcc85799e4706ca3b54e3a1d774d52b8d9bef6ef55909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4327454d65778e27b2c8c406bb639a677222afab3913adedbc79d59cff939e04"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/instaloader --login foo --password bar 2>&1", 1)
    assert_match "Fatal error: Login error:", output

    assert_match version.to_s, shell_output("#{bin}/instaloader --version")
  end
end
