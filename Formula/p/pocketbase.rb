class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.20.7.tar.gz"
  sha256 "2643f2ad1ec7981f554e4aa7a71a237016ba3814f4b19e7be4b02f8b0d5334cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0aca8b0cbcb14c127f5ab5ad39c1322be5d3e99ff3fdf6015e150fd9db7eed19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0aca8b0cbcb14c127f5ab5ad39c1322be5d3e99ff3fdf6015e150fd9db7eed19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aca8b0cbcb14c127f5ab5ad39c1322be5d3e99ff3fdf6015e150fd9db7eed19"
    sha256 cellar: :any_skip_relocation, sonoma:         "455845f366259b3b8643651f05580168f6b548db92ba603b3ecf473ba03dc557"
    sha256 cellar: :any_skip_relocation, ventura:        "455845f366259b3b8643651f05580168f6b548db92ba603b3ecf473ba03dc557"
    sha256 cellar: :any_skip_relocation, monterey:       "455845f366259b3b8643651f05580168f6b548db92ba603b3ecf473ba03dc557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f56167ebc3137b2b974e0c569d0313736dfca2641935444c11e654314c540a59"
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
