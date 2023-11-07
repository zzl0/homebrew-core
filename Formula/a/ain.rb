class Ain < Formula
  desc "HTTP API client for the terminal"
  homepage "https://github.com/jonaslu/ain"
  url "https://github.com/jonaslu/ain/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "af77c16f50a0ee2439f984e126b3b14da6efbd224617c59ca8ccffd62dbf11b9"
  license "MIT"
  head "https://github.com/jonaslu/ain.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitSha=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ain"
  end

  test do
    assert_match "http://localhost:${PORT}", shell_output("#{bin}/ain -b")
    assert_match version.to_s, shell_output("#{bin}/ain -v")
  end
end
