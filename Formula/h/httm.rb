class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.31.2.tar.gz"
  sha256 "f2621cc3e50848041e7b76ce2d813cde5dfe920b3c1c0987f61ed4bf5a416b83"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a62bd8caa5d309e1708488b6b3ea3e143043ec9b8dea79a44d253d955e995fb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea5c5b89b89d16ae3d41776b7938072d5fde3b573ec06b872d1f276f44fe001e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eefe4c0a3a9bacd38b5fc2da71a1a2cdf13e897dc88cdda740e4626d6b323aac"
    sha256 cellar: :any_skip_relocation, sonoma:         "7633d129cf9efb061268ac4efaee619faa717c5092ec638ef46900f13a86cf06"
    sha256 cellar: :any_skip_relocation, ventura:        "dcad669e8ee416288fc86014847f5d2adf1585ca5ea7c6952f856799bcb2c019"
    sha256 cellar: :any_skip_relocation, monterey:       "11a8d31fa1223995670add0f57fa0df51e7907ba80c406aec862b82982d2ce7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37143ebcb561b95dcca805255378baef537e03516760175fb14577afa260a180"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
