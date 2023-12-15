class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.13.0.tar.gz"
  sha256 "d4b4e0b347e54a5c0e9827486c5df9234d899ddadc311df4a147d9bf1877ad7a"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebaf3bcb5a7500a2a81e3025c7ad26c7e930c448e418765638a76c0799f57189"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e52bbe5d95574161d556b1063a4b6f7f889d86b260e3deba8a901a44e72a263"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf75d3306fe2cf8c4017e0bc2e35d709c83bf524bc866111162cdb345823f0d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fa9a5b3c0200d20b790443ce1722a97d73107b8881147e6b0a97ee8a817cdc0"
    sha256 cellar: :any_skip_relocation, ventura:        "821edd8f55be57ea939079610f75a52d13fce3c35c4865371797b543c720c268"
    sha256 cellar: :any_skip_relocation, monterey:       "64b9ae2aaa97966a6bb7f4d225971fe8f59e409a35a63cf60fbf59e0580f968f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f6cef60b8bed8b70a0ea4d3400310b0a556febf9ed5d9bec6c6ae557521725"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
