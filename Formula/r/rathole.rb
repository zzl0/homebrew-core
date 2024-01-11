class Rathole < Formula
  desc "Reverse proxy for NAT traversal"
  homepage "https://github.com/rapiz1/rathole"
  url "https://github.com/rapiz1/rathole/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c8698dc507c4c2f7e0032be24cac42dd6656ac1c52269875d17957001aa2de41"
  license "Apache-2.0"

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"rathole", "#{etc}/rathole/rathole.toml"]
    keep_alive true
    log_path var/"log/rathole.log"
    error_log_path var/"log/rathole.log"
  end

  test do
    bind_port = free_port
    service_port = free_port

    (testpath/"rathole.toml").write <<~EOS
      [server]
      bind_addr = "127.0.0.1:#{bind_port}"#{" "}
      default_token = "1234"#{" "}

      [server.services.foo]
      bind_addr = "127.0.0.1:#{service_port}"
    EOS

    read, write = IO.pipe
    fork do
      exec bin/"rathole", "-s", "#{testpath}/rathole.toml", out: write
    end
    sleep 5

    output = read.gets
    assert_match(/Listening at 127.0.0.1:#{bind_port}/i, output)

    assert_match(/Build Version:\s*#{version}/, shell_output("#{bin}/rathole --version"))
  end
end
