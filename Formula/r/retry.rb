class Retry < Formula
  desc "Repeat a command until the command succeeds"
  homepage "https://github.com/minfrin/retry"
  url "https://github.com/minfrin/retry/releases/download/retry-1.0.5/retry-1.0.5.tar.bz2"
  sha256 "68e241d10f0e2d784a165634bb2eb12b7baf0a9fd9d27c4d54315382597d892e"
  license "Apache-2.0"

  uses_from_macos "curl" => :test

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    require "socket"
    port = free_port
    command = "#{bin}/retry --delay 1 --until 0,28 -- curl --max-time 1 telnet://localhost:#{port}"
    _, stdout = Open3.popen2e(command)
    sleep 3

    assert_match "curl returned 7", stdout.read_nonblock(1024)

    fork do
      server = TCPServer.new port
      session = server.accept
      session.puts "Hello world!"
      session.close
      server.close
    end

    assert_match "Hello world!", stdout.read
  end
end
