class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "c0116bd7041898b2eb10d9d2b5537d31636a5f17ab2e536dd3ab7d9ade6e3b47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb61f11a84324abb1d1b7d669b67ee26290fa4f43cec24c006eb3c717be8d8ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6270e8a568324fa384a9381b4311ea2f717a340b7cbae4ca22114598687d89c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f170c81e3181582fdfd1c3db87534069e43a4ec1d55a3bc88305b78cb01a689f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b95016e86f0a0d87152fcfe901b44d66fcd51a8a2097d30e08cd66d9a2674bc1"
    sha256 cellar: :any_skip_relocation, ventura:        "f9ceccd6fd5db813e8a1a3ba85cef1113107f88c378faf8da1028b3d6708cd85"
    sha256 cellar: :any_skip_relocation, monterey:       "a62cfbb9083d2f5bfb39683c70dd2def19d64492ab831c7427fc95a81dab707c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd90ef0bf61508706735fea47776874e0645abef30b0c40723f3af1d773b5b43"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 1
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
