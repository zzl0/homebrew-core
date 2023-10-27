class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "d1e6d06cc005770475812118c98fc8602faa47609ef584a718364f0363b97100"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    output = shell_output("#{bin}/favirecon -u https://www.github.com")
    assert_match "[GitHub] https://www.github.com/favicon.ico", output
  end
end
