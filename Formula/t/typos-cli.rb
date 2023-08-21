class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.16.7.tar.gz"
  sha256 "77c3380bd995b1c5270e1d5d94abb2c838b32162c3a520030a158fac9e3949cb"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e303df24ffa556543f64275af28079fb1c520c665281335cb302668824ab49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed400377abb7db1803025400b378356ab371cf0f47fc108fb4ce47ac30b80d3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c42607dc143267544637455d6c35001d5ee949dfc7ecc82c75781d9b50f6523d"
    sha256 cellar: :any_skip_relocation, ventura:        "aa3e16f4eba304e81fa0b4bce3a008bb092f814171ca6d98239bb692ade2da1f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef8322d07c18c0522410210f76225a730a9662c62a9c189e4f9d554b9c4f432"
    sha256 cellar: :any_skip_relocation, big_sur:        "1abd7ea9a305ce58d122a054f9a3577c089a5921cfca2810a4f85d77c0c63bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546c4f3a7ff66e16727b725c367d0c3e80d3b1e9206ccecd7db40d8bc179b5b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
