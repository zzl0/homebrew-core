class Tccutil < Formula
  include Language::Python::Shebang

  desc "Utility to modify the macOS Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://github.com/jacobsalmela/tccutil/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b585da1cc342e2880a601c88ff0e4d8fd65f22146bd1f581a3f41608c76d0523"
  license "GPL-2.0-or-later"
  head "https://github.com/jacobsalmela/tccutil.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "d57eaab2e7dac4348893666c3b32c01270c28d77be17ad6de74c190f7b620efb"
  end

  depends_on :macos
  depends_on "python-packaging"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    rewrite_shebang detected_python_shebang, "tccutil.py"
    bin.install "tccutil.py" => "tccutil"
  end

  test do
    assert_match "Unrecognized command \"check\"", shell_output("#{bin}/tccutil check 2>&1")
    assert_match "tccutil #{version}", shell_output("#{bin}/tccutil --version")
  end
end
