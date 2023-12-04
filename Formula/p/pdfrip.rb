class Pdfrip < Formula
  desc "Multi-threaded PDF password cracking utility"
  homepage "https://github.com/mufeedvh/pdfrip"
  url "https://github.com/mufeedvh/pdfrip/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "911cd38805ca31cf941eebdf1a7d465bd6ad47d7c4603a5a896a2d3d67598996"
  license "MIT"
  head "https://github.com/mufeedvh/pdfrip.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfrip --version")

    touch testpath/"test.pdf"
    output = shell_output("#{bin}/pdfrip test.pdf --num-bruteforce 1-5 2>&1")
    assert_match "None of those were the password :(", output
  end
end
