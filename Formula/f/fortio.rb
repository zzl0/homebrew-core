class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.62.1",
      revision: "a95f803d5082c3745ae02315bbc24f1608182009"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f56c1342484bf379ffceff5b6f16af48fac8aa422fe5116c9db2fde5f926684"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "457f9835e3c392bec7d3a22b00a59d10c88ceeb0ba93f1263b2a4ed658ab9f9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5ccaf25cc14b7ce5811faa9e6c74b5620992cdc652251ad7fba59e117b4d60f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e73fe805f2d4bb99d81c040a9acf379fd1d8111662ea5ec5c5464388695c8b0"
    sha256 cellar: :any_skip_relocation, ventura:        "aeb6b6cea08d99a7aa7df7edf940bab2ef68f81ea5135ef038e3fea5810a9ce1"
    sha256 cellar: :any_skip_relocation, monterey:       "5eb4437f5560426a86ffceb1c582407a1fda1e9ba69aa2d4be59032052514910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d565e1738f4d8ef95ae96fb20508e4eaad5583eda4b34c9dd0dbfb3649b48604"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
