class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "df8d71ae46a0c9a29e68ced233fdc3a73f4068b9098e7c6b5bc4679019ffe1d9"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58ec21b9754af33112168f4878cbe6035e9da081baba466208ccdad4d2b11704"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c6dac4fcbb6d1b0c9e0f2046ca1a2dda7b79f76258c94e240ed328ea0b5226d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c6dac4fcbb6d1b0c9e0f2046ca1a2dda7b79f76258c94e240ed328ea0b5226d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c6dac4fcbb6d1b0c9e0f2046ca1a2dda7b79f76258c94e240ed328ea0b5226d"
    sha256 cellar: :any_skip_relocation, sonoma:         "316ed35b9e300f40c281a97e047283a3e1da1bdb8b3ee11c79800c0dd6f44902"
    sha256 cellar: :any_skip_relocation, ventura:        "2f9651e421727a2314a952f1ffe678b308205abfed8144ac56b4178244a9c4b4"
    sha256 cellar: :any_skip_relocation, monterey:       "2f9651e421727a2314a952f1ffe678b308205abfed8144ac56b4178244a9c4b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f9651e421727a2314a952f1ffe678b308205abfed8144ac56b4178244a9c4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c6dac4fcbb6d1b0c9e0f2046ca1a2dda7b79f76258c94e240ed328ea0b5226d"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
