class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.7.2.tar.gz"
  sha256 "921d23dffb913b18216433aebf8a2c8fb6d4df7d1e4d2fefc488bd0719eeb9c2"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e1dfe5c4528e9c02caf03090b748164727456233ae4bef2f026d0c025c5c05f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1dfe5c4528e9c02caf03090b748164727456233ae4bef2f026d0c025c5c05f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e1dfe5c4528e9c02caf03090b748164727456233ae4bef2f026d0c025c5c05f"
    sha256 cellar: :any_skip_relocation, ventura:        "e10224ef7981c7a1faeb07f526b12baf343386f56eb057314cd1e701a68be743"
    sha256 cellar: :any_skip_relocation, monterey:       "e10224ef7981c7a1faeb07f526b12baf343386f56eb057314cd1e701a68be743"
    sha256 cellar: :any_skip_relocation, big_sur:        "e10224ef7981c7a1faeb07f526b12baf343386f56eb057314cd1e701a68be743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df80fa75cb87fefce4c9db360eed46d58bb9106dae9ead31817e482426c08f34"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.3.4.tar.gz"
    sha256 "5ff7b73c2601ceaf3fd1b3d92be49244523b9b98ee6127276d54c4df59a73d28"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end

    generate_completions_from_executable("go", "run", "cmd/caddy/main.go", "completion")
  end

  service do
    run [opt_bin/"caddy", "run", "--config", etc/"Caddyfile"]
    keep_alive true
    error_log_path var/"log/caddy.log"
    log_path var/"log/caddy.log"
  end

  test do
    port1 = free_port
    port2 = free_port

    (testpath/"Caddyfile").write <<~EOS
      {
        admin 127.0.0.1:#{port1}
      }

      http://127.0.0.1:#{port2} {
        respond "Hello, Caddy!"
      }
    EOS

    fork do
      exec bin/"caddy", "run", "--config", testpath/"Caddyfile"
    end
    sleep 2

    assert_match "\":#{port2}\"",
      shell_output("curl -s http://127.0.0.1:#{port1}/config/apps/http/servers/srv0/listen/0")
    assert_match "Hello, Caddy!", shell_output("curl -s http://127.0.0.1:#{port2}")

    assert_match version.to_s, shell_output("#{bin}/caddy version")
  end
end
