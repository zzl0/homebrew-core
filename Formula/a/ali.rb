class Ali < Formula
  desc "Generate HTTP load and plot the results in real-time"
  homepage "https://github.com/nakabonne/ali"
  url "https://github.com/nakabonne/ali/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "3eed2d7cbdf8365cad78833362e99138e7c0945d6dbc19e1253f8e0438a72f81"
  license "MIT"
  head "https://github.com/nakabonne/ali.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit= -X main.date=#{time.iso8601}}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output(bin/"ali --duration=10m --rate=100 http://host.xz 2>&1", 1)
    assert_match "failed to start application: failed to generate terminal interface", output

    assert_match version.to_s, shell_output("#{bin}/ali --version 2>&1")
  end
end
