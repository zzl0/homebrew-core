class Bkcrack < Formula
  desc "Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
  homepage "https://github.com/kimci86/bkcrack"
  url "https://github.com/kimci86/bkcrack/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "ad33a72be3a6a0d29813cbb5f5837281f274cb3e13a534202afccd2c623329d0"
  license "Zlib"
  head "https://github.com/kimci86/bkcrack.git", branch: "master"

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/src/bkcrack"
    pkgshare.install "example"
  end

  test do
    output = shell_output("#{bin}/bkcrack -L #{pkgshare}/example/secrets.zip")
    assert_match "advice.jpg", output
    assert_match "spiral.svg", output

    assert_match version.to_s, shell_output("#{bin}/bkcrack --help")
  end
end
