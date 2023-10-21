class Jprq < Formula
  desc "Join Public Router, Quickly"
  homepage "https://jprq.io/"
  url "https://github.com/azimjohn/jprq/archive/refs/tags/2.2.tar.gz"
  sha256 "6121e0ac74512052ed00c57c363f0f0b66910618ebd8134cfa72acca05b09163"
  license "BSD-3-Clause"
  head "https://github.com/azimjohn/jprq.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cli"
  end

  test do
    assert_match "auth token has been set", shell_output("#{bin}/jprq auth jprqbolmagin 2>&1")
    output = shell_output("#{bin}/jprq serve #{testpath} 2>&1", 1)
    assert_match "authentication failed", output

    assert_match version.to_s, shell_output("#{bin}/jprq --version 2>&1")
  end
end
