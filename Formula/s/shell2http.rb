class Shell2http < Formula
  desc "Executing shell commands via HTTP server"
  homepage "https://github.com/msoap/shell2http"
  url "https://github.com/msoap/shell2http/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "90aa95c7b7bdb068b5b4a44e3e6782cda6b8417efbd0551383fb4f102e04584c"
  license "MIT"
  head "https://github.com/msoap/shell2http.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    man1.install "shell2http.1"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/shell2http", "-port", port.to_s, "/echo", "echo brewtest"
    end
    sleep 1
    output = shell_output("curl -s http://localhost:#{port}")
    assert_match "Served by shell2http/#{version}", output

    output = shell_output("curl -s http://localhost:#{port}/echo")
    assert_match "brewtest", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
