class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/0a/b5/ec7799b29199420b8263526dba8cafe6a4a57de70086453291244b25596c/yle_dl-20231120.tar.gz"
  sha256 "35a0a077c32184ee993ef953ec9a74098399b3094009d562cc3638470d745218"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73838c6fb8b06ddc83e761a5f6dee574afa9f51aeb33de847528e1ccc1298cb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c91821cae7038c5f5c8a1ee63741d5f769075a2247e863a1f9b9d1df51ed233d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cd2e4de873b1c8634b52d598d9710f933f7b6775ba148e692cfc8c6fbe7e6b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7aa83ca9bfc09ebf3106a4e9bff5f1e8df1b477c1d2e727d807a48b7752d556"
    sha256 cellar: :any_skip_relocation, ventura:        "15d8f291c7b887cc0d8825d6355cdd85c4d3943e0ea5b6bd8784a4a7a6e42adb"
    sha256 cellar: :any_skip_relocation, monterey:       "2019d62b86ab80f52ca681e6804a9dacc336aadf0b324ab4a7db1407be7336fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038c5ebfe9471f345640630ecd9509032b3e17357b58feb639f0d615d5279e85"
  end

  depends_on "python-flit-core" => :build
  depends_on "cffi"
  depends_on "ffmpeg"
  depends_on "pycparser"
  depends_on "python-configargparse"
  depends_on "python-lxml"
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
