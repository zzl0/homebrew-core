class Sshportal < Formula
  desc "SSH & Telnet bastion server"
  homepage "https://v1.manfred.life/sshportal/"
  url "https://github.com/moul/sshportal/archive/refs/tags/v1.19.5.tar.gz"
  sha256 "713be8542c93d91811f9643a8a2954ebc15130099e300fedb5ea4785b5337b52"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.GitSha=#{tap.user}
      -X main.GitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sshportal --version")

    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/sshportal server 2>&1")
    sleep 2
    assert_match "info: system migrated", stdout.readline
  end
end
