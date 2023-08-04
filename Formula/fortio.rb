class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.57.5",
      revision: "bddad000c61bbd099b6e7d8f8f978771bca3aacd"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5d53042c975e2539edfd84ecb3b701650414d96533f7e9071d19cd185916142"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d44b9ef00423fa119488d66d078376ad8b2ae86a5f0c3d2a70250b31a37b87e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fce845c7838a44c5c1591ca735bfcf6dc40559a23af8c5e131141f0a5e4dc642"
    sha256 cellar: :any_skip_relocation, ventura:        "6ebed431cea87464a95627845ec06a07dca9ab97a6371a8869296c55df920d2d"
    sha256 cellar: :any_skip_relocation, monterey:       "ab45298f6beca6d4966f3e3c9d86fdc62d15128968c3e67b6a1b955d4703543a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bc745405a042dbb09031ddda1299ffedbb871484ba60f3c83233bf2f9736b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4306b7381680f205ceda197fef57ab81a5b733459f8a868a6220e5b41ea0d21"
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
