class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "0c2ecd12460ee8549ed42ad9a4d02a4824fb08b93527a393e0bdc5d43e16ab9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a58afb8306ec38d410ed7c07c4d38ed8bb0aeb9e3dbe2fdf32953cead93f1e1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20a445d8199f20147c9d3c8e7ae6362a2dc5f05e8147f747bac838b5eee89b4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "315d5399a415cf78df0355b51e17a100cbec5cb5ca0f0234440823f3ec3a383b"
    sha256 cellar: :any_skip_relocation, ventura:        "e06e7d9b2e099a5b685c67cda605b5d288e5f60a8f2b90ec86fc7d8d81c271b2"
    sha256 cellar: :any_skip_relocation, monterey:       "9eebd44bd334a8e4b9d255f9b146ca87eacd12586608bfe4048e422631e6be6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad63a5750b0fc1dd215307435d143bc65178f80c36e416d2d4bd7c422dc8e7f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "214b3ae674dc7f3b13265dc159c270fe90c66a6f4b1568fb082ea9c70a292a20"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/agent/pkg/build.Branch=HEAD
      -X github.com/grafana/agent/pkg/build.Version=v#{version}
      -X github.com/grafana/agent/pkg/build.BuildUser=#{tap.user}
      -X github.com/grafana/agent/pkg/build.BuildDate=#{time.iso8601}
    ]
    args = std_go_args(ldflags: ldflags) + %w[-tags=builtinassets,noebpf]

    # Build the UI, which is baked into the final binary when the builtinassets
    # tag is set.
    cd "web/ui" do
      system "yarn"
      system "yarn", "run", "build"
    end

    system "go", "build", *args, "./cmd/grafana-agent"
    system "go", "build", *args, "-o", bin/"grafana-agentctl", "./cmd/grafana-agentctl"
  end

  def post_install
    (etc/"grafana-agent").mkpath
  end

  def caveats
    <<~EOS
      The agent uses a configuration file that you must customize before running:
        #{etc}/grafana-agent/config.yml
    EOS
  end

  service do
    run [opt_bin/"grafana-agent", "-config.file", etc/"grafana-agent/config.yml"]
    keep_alive true
    log_path var/"log/grafana-agent.log"
    error_log_path var/"log/grafana-agent.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grafana-agent --version")
    assert_match version.to_s, shell_output("#{bin}/grafana-agentctl --version")

    port = free_port

    (testpath/"wal").mkpath

    (testpath/"grafana-agent.yaml").write <<~EOS
      server:
        log_level: info
    EOS

    system bin/"grafana-agentctl", "config-check", "#{testpath}/grafana-agent.yaml"

    fork do
      exec bin/"grafana-agent", "-config.file=#{testpath}/grafana-agent.yaml",
        "-metrics.wal-directory=#{testpath}/wal", "-server.http.address=127.0.0.1:#{port}",
        "-server.grpc.address=127.0.0.1:#{free_port}"
    end
    sleep 10

    output = shell_output("curl -s 127.0.0.1:#{port}/metrics")
    assert_match "agent_build_info", output
  end
end
