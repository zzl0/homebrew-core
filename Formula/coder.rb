class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "a9c2a996cb916ef0d74c1cdd2ccf30f95b9953618ce2d504a7477eb2b8b655c2"
  license "AGPL-3.0-only"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/buildinfo.tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/coder"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/coder version")
    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
    assert_match "postgres://", shell_output("#{bin}/coder server postgres-builtin-url")
  end
end
