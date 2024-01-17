class TerrapinScanner < Formula
  desc "Vulnerability scanner for the Terrapin attack"
  homepage "https://terrapin-attack.com/"
  url "https://github.com/RUB-NDS/Terrapin-Scanner/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "f804944de6a2afa061433ddb9d393a9247e8392bf1eb76ccce92175bceb99dab"
  license "Apache-2.0"
  head "https://github.com/RUB-NDS/Terrapin-Scanner.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"Terrapin-Scanner")
  end

  test do
    output = shell_output("#{bin}/Terrapin-Scanner --connect localhost:2222 2>&1", 2)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/Terrapin-Scanner --version")
  end
end
