class Signmykey < Formula
  desc "Automated SSH Certificate Authority"
  homepage "https://signmykey.io"
  url "https://github.com/signmykeyio/signmykey/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "162176a7a32c0c2a47707680d45662a8b68e18488c6d6fa76a05d07933bef6e2"
  license "MIT"
  head "https://github.com/signmykeyio/signmykey.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/signmykeyio/signmykey/cmd.versionString=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"signmykey", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/signmykey version")

    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/signmykey server dev -u myremoteuser")
    sleep 2
    assert_match "Starting signmykey server in DEV mode", stdout.readline
  end
end
