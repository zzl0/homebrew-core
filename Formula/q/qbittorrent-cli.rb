class QbittorrentCli < Formula
  desc "Command-line interface for qBittorrent written in Go"
  homepage "https://github.com/ludviglundgren/qbittorrent-cli"
  url "https://github.com/ludviglundgren/qbittorrent-cli/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "91969f22bb167f99091a1ff8f4dbfe61cb1b592cb000453859ca9173ecbb8f10"
  license "MIT"
  head "https://github.com/ludviglundgren/qbittorrent-cli.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"qbt"), "./cmd/qbt"

    generate_completions_from_executable(bin/"qbt", "completion")
  end

  test do
    port = free_port
    (testpath/"config.qbt.toml").write <<~EOS
      [qbittorrent]
      addr = "http://127.0.0.1:#{port}"
    EOS

    output = shell_output("#{bin}/qbt app version --config #{testpath}/config.qbt.toml 2>&1", 1)
    assert_match "could not get app version", output

    assert_match version.to_s, shell_output("#{bin}/qbt version")
  end
end
