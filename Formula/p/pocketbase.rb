class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "2d10e8b868e0bb7067fba63a02ea98f2925d2854586870be96a98e97d7aaeb52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb81d760d8e582f75e333bf92c2646c590661d36bd01e8a583bc68bc3c6447bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb81d760d8e582f75e333bf92c2646c590661d36bd01e8a583bc68bc3c6447bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb81d760d8e582f75e333bf92c2646c590661d36bd01e8a583bc68bc3c6447bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b4ab50a2b261f8780820614482155bbf5445629366bac7dd6a331863e24abbe"
    sha256 cellar: :any_skip_relocation, ventura:        "7b4ab50a2b261f8780820614482155bbf5445629366bac7dd6a331863e24abbe"
    sha256 cellar: :any_skip_relocation, monterey:       "7b4ab50a2b261f8780820614482155bbf5445629366bac7dd6a331863e24abbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64de3a2b355cbd7ebfb051342e36a4345f1ec524b9411ef030e09d9c59ba804a"
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
