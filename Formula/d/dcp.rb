class Dcp < Formula
  desc "Docker cp made easy"
  homepage "https://github.com/exdx/dcp"
  url "https://github.com/exdx/dcp/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "7d9caa94c6a099762f367901cb0ccbe63130026f903e5477f4403d0cfff98b53"
  license "MIT"
  head "https://github.com/exdx/dcp.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/dcp busybox 2>&1", 1)
    assert_match "docker socket not found: falling back to podman configuration", output

    assert_match version.to_s, shell_output("#{bin}/dcp --version")
  end
end
