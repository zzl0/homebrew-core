class Yatas < Formula
  desc "Tool to audit AWS/GCP infrastructure for misconfiguration or security issues"
  homepage "https://github.com/padok-team/yatas"
  url "https://github.com/padok-team/yatas/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "53abe26a7025aabf73918e3153c66d91cc5567e2fcd6df388e7c82e36704bd0e"
  license "Apache-2.0"
  head "https://github.com/padok-team/yatas.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"yatas", "--init"
    output = shell_output("#{bin}/yatas --install 2>&1")
    assert_match "failed to refresh cached credentials, no EC2 IMDS role found", output
  end
end
