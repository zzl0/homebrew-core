class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/mozilla/cbindgen"
  url "https://github.com/mozilla/cbindgen/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "363ac6317a5788de8f2b0104a472a747883d4b9126fa119c681879509dbdbc28"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b1338c2d9993ef251a5f4bef30e84faffd829b5e6f3356a913aa1925b920bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "719d92a84950014bec92d2ff31617080ddc6d7fd7af3b9ebb00cb32c85d6d4c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "293f958b49e0707ef8908b0eb97181c426fe619e6440c399c188116e98a11337"
    sha256 cellar: :any_skip_relocation, ventura:        "d959fe4eeeecaa1c9f6c040b4fee08d40744404eafc83d495138bd931cd096d3"
    sha256 cellar: :any_skip_relocation, monterey:       "9a5db4574eea9fde760d8a7b3a3f06258ef1b1e944abc92ed0fccd1262535127"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c555fc199fbb8a56ce5dc00d75ef2a54d399e6b2f69a1ae577a13dffd73f92d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2256beab40556351f3ffb921ce8a8b53cfedd2dfcb4f83750ef1f8343ea8366"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/rust/extern.rs", testpath
    output = shell_output("#{bin}/cbindgen extern.rs")
    assert_match "extern int32_t foo()", output
  end
end
