class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "6a6f08e643a4b4e5ac440c5db11c7e36d2c1bee058ed7e0ca86d14b403733d5e"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a5790eae48a6b66dd811301e209f694246612ecbff94e39857a1b5f73c8a3771"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
