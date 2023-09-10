class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.45.tar.gz"
  sha256 "c3980ebb0c0ce825f0e50a3ae9f5e8d1af4b5b712bc99c4cff2205b594cba99a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7852dd57de8161a6838d4b8d228e2c0b68d591746e7d58171a8ad17f6684bc64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9014570f6e40383dc0353c6904a87eab38f399e2c65adb2a981209ae8935f61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6e417d71bbc42d8cda8f6b609664943ba4108ce26fa565ab1953624b4603146"
    sha256 cellar: :any_skip_relocation, ventura:        "3da1bbbd2bcaa9c23ac9088ee5b1c928f852e8d38b3d4655674a04a7e761b0b4"
    sha256 cellar: :any_skip_relocation, monterey:       "d92b23487bf18aba42841ef4015e843cc1d29787912b6f5d1736d291c8ed9faf"
    sha256 cellar: :any_skip_relocation, big_sur:        "791447456592d82424005662112c36f91213b25fbd5699fbda1c7fc92652ef24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db8711d040399b296414af40e0b181e4d2b2e0bdfcc34456be31af9fd1550f75"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
