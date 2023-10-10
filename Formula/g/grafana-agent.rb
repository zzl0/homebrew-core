class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "36184a526bbb3be276bfa67185c2ad05966768eb8dfef0890cd1f9328c4f70d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3e6e78455884a57425402bc6c545778d5b81b63c9de3faa202c567726b1910a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94ac0f42c89cbcaca859c8d8bb6cae55a00b6360cf642b5777f64607ca6ad27c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b042c1e792d3aac59edb31c7bb747a291d92c1e5899672a932a8c780b8964fb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "690f7234e8231b1aa7d94b288e7142d5a46a533b7e76acadb961140f6cf31554"
    sha256 cellar: :any_skip_relocation, ventura:        "8d6ccaa57e4c8ceb470da5d31e3b278da2033a9cb190fd923af17747100641bb"
    sha256 cellar: :any_skip_relocation, monterey:       "8eb9f4c0b617b655f965bda4b2e4fe2ee3913ae9036cefbe10ac122b9d929e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c49ea0e4becb4224258386e63e3f79ea8f569ba914a8580b0a80ff098208a59"
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
