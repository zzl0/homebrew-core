class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/filiptibell/lune/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "9c29f240d614c8af8d7d0a7903a02d084f5df1280818d9f623a47a2f7a86504f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a0ebc0879a27219f67e2c8159e4119e0d776646e3d822f1a21ea73615499299"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ea828b044c1abc26d7ab128ad56e826eda8195d6706fbc142e44c313b2ed95e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05d029cafc6b1189dcd70bca88140e146a36eb8bf6885daf1a246f1c460f4c12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1d5b9673a25ff3e4be192991ade81fa119d7f6152bd2672c191eb8ca5cef16f"
    sha256 cellar: :any_skip_relocation, sonoma:         "575cf9edfcdb50463fe9d1e39d740edc52b7602fda86643d401daca7224790ea"
    sha256 cellar: :any_skip_relocation, ventura:        "485a24de18876afa5c2fad739975f35a46c590dccc959276569ad3b6a8e50b62"
    sha256 cellar: :any_skip_relocation, monterey:       "2c50229eef76293184d0a26ab53fe0523ed9b5f3a682a36c768892d41cc36193"
    sha256 cellar: :any_skip_relocation, big_sur:        "1df25b8302cf9253d3f80b180799e0b514efb35692a20f11c4fe72f64685a0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5b5a86e88d056cb51ee27ddb900395025b1bed4d128f5f4d27a8867e6f73d54"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune test.lua").chomp
  end
end
