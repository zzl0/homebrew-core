class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.10.0.tar.gz"
  sha256 "026d41f4a6a9239b7c6343f261340e1b41f7dd9011ed3a8753eb50c55dd6b471"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e01bd1a2c9112f3f0cd4edd77f3d5a9213098f259765739bfdf23b734708fca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b336e803efbab521953926c5430cbc72fcacd91d17e3f4ffe18954bf1c4f5bfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5c0f1cd3f9130a15eebc984e30cda85b5c7f7e28e54d0698556db16d56dd786"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b576a918c03b7a73a5fb83583f6ae784d6802a6cecf190324165151e87adb85"
    sha256 cellar: :any_skip_relocation, ventura:        "7b566b43099f494cd543d99033ea265e84d7c2d70a4a5eac0a64f9ae73d3fda2"
    sha256 cellar: :any_skip_relocation, monterey:       "df46f9c17a51b0822f985e31fccd79e0907133fb696b577e3cb6407fefbaa1a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcad8f07bc7bd29503800baf1d9665339ce35c51089f7f412e384f7fd822785a"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
