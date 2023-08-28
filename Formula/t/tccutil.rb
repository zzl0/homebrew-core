class Tccutil < Formula
  include Language::Python::Shebang

  desc "Utility to modify the macOS Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://github.com/jacobsalmela/tccutil/archive/v1.2.13.tar.gz"
  sha256 "b0e3f660857426372588b0f659056a059ccbd35a4c91538c75671d960cb91030"
  license "GPL-2.0-or-later"
  head "https://github.com/jacobsalmela/tccutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aafbd63cacbfe93a5b73db49233dd31cc2baa9a1d4c971b18b7db1cc5e620de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6abb29de36bab0c0b4a6a700b9d53ba3d5d2c60afebf1c5f783d7a08e4618014"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c73485c2e63ce837d7c4bf8aac4d9a8fd87294e9ec551f416b85a5dd188109bd"
    sha256 cellar: :any_skip_relocation, ventura:        "2416cb241f6a8e985f94aca9c270fa5d38e3c49ccd159fb8d859efcbda32d027"
    sha256 cellar: :any_skip_relocation, monterey:       "a6a65e5366da57ad3defe1ede9fb4b01333f94b1e98c7ba4d4a552f92155fd12"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ae37f45387baeb609da0fc88b3d812fe3707100fefed42ca4e506276632f9d4"
  end

  depends_on :macos
  depends_on "python-packaging"
  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    rewrite_shebang detected_python_shebang, "tccutil.py"
    bin.install "tccutil.py" => "tccutil"
  end

  test do
    assert_match "Unrecognized command check", shell_output("#{bin}/tccutil check 2>&1")
    assert_match "tccutil #{version}", shell_output("#{bin}/tccutil --version")
  end
end
