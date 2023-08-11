class Asnmap < Formula
  desc "Quickly map organization network ranges using ASN information"
  homepage "https://github.com/projectdiscovery/asnmap"
  url "https://github.com/projectdiscovery/asnmap/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "e29eddad2a760f012e6b33973d199d7a7f8ae0b3af72c84359c426b1b0cf639f"
  license "MIT"
  head "https://github.com/projectdiscovery/asnmap.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/asnmap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asnmap -version 2>&1")
    assert_match "1.1.1.0/24", shell_output("#{bin}/asnmap -i 1.1.1.1")
  end
end
