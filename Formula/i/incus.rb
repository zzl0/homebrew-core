class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-0.1.tar.gz"
  sha256 "771b6f438e369f729eaaa6dfd938f14dcc8de09dbc9da23c7c80c6d14f02653b"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
