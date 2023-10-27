class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "0a722fa9cc16c408eeb1cbf4e884a061407aa7a5d24beeb7d9bc8ceecf214d4f"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end
