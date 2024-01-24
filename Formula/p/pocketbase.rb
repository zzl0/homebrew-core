class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "2a1dc9a88438a7af263ee5acd0b837645eb127a995a20072ba3efde51cc12b07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d1ab4d9973a6466dc3648f9d2a5ec6b9c9b8dea19fe07348a1cee2e953822c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d1ab4d9973a6466dc3648f9d2a5ec6b9c9b8dea19fe07348a1cee2e953822c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d1ab4d9973a6466dc3648f9d2a5ec6b9c9b8dea19fe07348a1cee2e953822c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "89c4731c225a4661263b479ef363c55c7c572016c042701345ea9de1a6d42665"
    sha256 cellar: :any_skip_relocation, ventura:        "89c4731c225a4661263b479ef363c55c7c572016c042701345ea9de1a6d42665"
    sha256 cellar: :any_skip_relocation, monterey:       "89c4731c225a4661263b479ef363c55c7c572016c042701345ea9de1a6d42665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47b17026dd0f6140ed587158d047020c1635e1ca1e00554fe841697ce9ae6b77"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port
    Process.kill "SIGINT", pid

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end
