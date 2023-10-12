class WormholeWilliam < Formula
  desc "End-to-end encrypted file transfer"
  homepage "https://github.com/psanford/wormhole-william"
  url "https://github.com/psanford/wormhole-william/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "a335d2f338ef61ee4bb12ce9adc5ab57652ca32e7ef05bfecaf0a0003b418854"
  license "MIT"
  head "https://github.com/psanford/wormhole-william.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wormhole-william", "shell-completion")
  end

  test do
    # Send "foo" over the wire
    code = "#{rand(1e12)}-test"
    pid = fork do
      exec "#{bin}/wormhole-william", "send", "--code", code, "--text", "foo"
    end

    # Give it some time
    sleep 2

    # Receive the text back
    assert_match "foo\n", shell_output("#{bin}/wormhole-william receive #{code}")
  ensure
    Process.wait(pid)
  end
end
