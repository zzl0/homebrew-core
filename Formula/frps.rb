class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.51.3",
      revision: "466d69eae08e44f118302cf433d3f4d6e8d04893"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7f848d33b00c7596f06a88aac80a448f816fdafd09bf745ade530ef99b14abb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7f848d33b00c7596f06a88aac80a448f816fdafd09bf745ade530ef99b14abb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7f848d33b00c7596f06a88aac80a448f816fdafd09bf745ade530ef99b14abb"
    sha256 cellar: :any_skip_relocation, ventura:        "01e6f6e285dbe3c7aa0a24fdc3715aa42ce0d5170c056abcfad8adaa750fe6c2"
    sha256 cellar: :any_skip_relocation, monterey:       "01e6f6e285dbe3c7aa0a24fdc3715aa42ce0d5170c056abcfad8adaa750fe6c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "01e6f6e285dbe3c7aa0a24fdc3715aa42ce0d5170c056abcfad8adaa750fe6c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2805003ff9809147c2dddd604ed6afad698b6800015015a78ada172f16862d11"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.ini" => "frp/frps.ini"
    etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.ini"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
