class ChiselTunnel < Formula
  desc "Fast TCP/UDP tunnel over HTTP"
  homepage "https://github.com/jpillora/chisel"
  url "https://github.com/jpillora/chisel/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "7323fb3510a36f14949337cd03efd078f4a5d6159259c20539e3a8e1960a7c7e"
  license "MIT"
  head "https://github.com/jpillora/chisel.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"chisel", ldflags: "-X github.com/jpillora/chisel/share.BuildVersion=v#{version}")
  end

  test do
    _, write = IO.pipe
    server_port = free_port

    server_pid = fork do
      exec "#{bin}/chisel server -p #{server_port}", out: write, err: write
    end

    sleep 2

    begin
      assert_match "Connected", shell_output("curl -v 127.0.0.1:#{server_port} 2>&1")
    ensure
      Process.kill("TERM", server_pid)
      Process.wait(server_pid)
    end
  end
end
