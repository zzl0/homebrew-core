class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "0db8409bf4fd220f2a3da7c44fa69908acc8919ad420b4aac71dbc7298538460"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a7efc5c5fbe00e6f318da315728e295af9535f258b51863b60a4d321d9a55f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a7efc5c5fbe00e6f318da315728e295af9535f258b51863b60a4d321d9a55f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a7efc5c5fbe00e6f318da315728e295af9535f258b51863b60a4d321d9a55f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "494e5be533bf553cecee58665bae5ec1bf25cde95e7ba8649c4dd3836d0c22f4"
    sha256 cellar: :any_skip_relocation, ventura:        "494e5be533bf553cecee58665bae5ec1bf25cde95e7ba8649c4dd3836d0c22f4"
    sha256 cellar: :any_skip_relocation, monterey:       "494e5be533bf553cecee58665bae5ec1bf25cde95e7ba8649c4dd3836d0c22f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5d78ce24247c188cc5f82492e790739e3768f8e1706afdb62a5224fb28b8c3"
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
