class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.20.6.tar.gz"
  sha256 "eb8e6d1bb6bce80522deb1651dfb4ca44b99ec3aba39450fef59e23ef3600b5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bca8247b99ce929c203d4a67dd4397771e10dccf3fc56b6c5ddfe3a79a3d426"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bca8247b99ce929c203d4a67dd4397771e10dccf3fc56b6c5ddfe3a79a3d426"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bca8247b99ce929c203d4a67dd4397771e10dccf3fc56b6c5ddfe3a79a3d426"
    sha256 cellar: :any_skip_relocation, sonoma:         "30133d2ab7a897974055375653c890cea7ae28ca973b349509907e64470516f1"
    sha256 cellar: :any_skip_relocation, ventura:        "30133d2ab7a897974055375653c890cea7ae28ca973b349509907e64470516f1"
    sha256 cellar: :any_skip_relocation, monterey:       "30133d2ab7a897974055375653c890cea7ae28ca973b349509907e64470516f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5375dd98d4d28b912fbb8127bfa300dfc8d83f29bb69d11b880778dd554244d"
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
