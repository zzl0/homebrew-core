class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "52f852beddba06556ac0b83172f472882bd0c66a172de1559773e2aeb112ef0a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad296fa7d5d5f4bddab8643445cca865f0fefc3e6a85977f20df24626c701559"
    sha256 cellar: :any,                 arm64_ventura:  "198d0e847b766801c5d60d2c579389eab5eabdabd9cdadf37de2394e44bbbb1c"
    sha256 cellar: :any,                 arm64_monterey: "d8e122dc12e858c37fa3543133bfd90821967c23d8f08496a0ac1faae22dad7b"
    sha256 cellar: :any,                 arm64_big_sur:  "0e2e752af3b231858b81aa1b2b847f928e2089f046387ae9a17a6305d9ddaced"
    sha256 cellar: :any,                 sonoma:         "d6d198474da8a629d0ad4f3d3fecfc9470b81c1737ee3aadd9b99ea7f177007e"
    sha256 cellar: :any,                 ventura:        "460607d57628615309f92ccd80247e853ed32b0d96e08ca40f46c9496c005c32"
    sha256 cellar: :any,                 monterey:       "c2e392279e213a08a87562e67de199c0350616ba443dd55c683e92e722e72275"
    sha256 cellar: :any,                 big_sur:        "b99ea5c4f72a8cbd63073a3b7af6e0b608daa284affaa015e9ab9c29c4475814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f188b49b3dab04632c23705b879b089a845b992ba3a28fa900f5990061e3cd0c"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end
