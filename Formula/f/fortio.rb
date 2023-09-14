class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.60.1",
      revision: "dcad10f29dab524eeb5a94c3037a63d04f101310"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f7960a229c8aa26792b68ec0f7f507144cf443a225dbcdd1c6335b50ce334fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43f01b0b1451f5f67b723e33d3d18e3254c0554fa7fe95511e56dd97eee685ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c918a05dda8d882726e849a14607bc04a6eac186159920f370d652f7a4f0dd5"
    sha256 cellar: :any_skip_relocation, ventura:        "6576c7d65f19ff28bbe48da1127c1756387d4220c5e44c93614e69df7f86bbbd"
    sha256 cellar: :any_skip_relocation, monterey:       "b234e4896eeea31665854e56c17dbb76f8197c61c8c001fbc2f4f487bd39b42e"
    sha256 cellar: :any_skip_relocation, big_sur:        "42b72aefa4fed5ea85e41b164e8550425a9e076955534c9f88e74dcafe853635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76edf64aa562b2938042988c51d09d09259b3e85bfc9eb6d897de8600476da37"
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
