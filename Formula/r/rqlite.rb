class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.16.4.tar.gz"
  sha256 "d170748cf35adb2a56729ec1c110ffb4579a26f32d031e59770cff5b73d796c8"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f18c5f759450eabd7493acb4e2fa2a14ca4a145048c1e8985ec2a7d3a7baea6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93a3cfb30a2874d60646ee6e8118e7f9ea7b5cbe29bd891a6bd47f41db57b62a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cd2ac68cf531522c7cfd485e02ee34edb498dc93596a0a9f81e2cbc98ada6c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7236ddec48b8b8f81106006d0a652e177b1d41b46130d3119f4b558637a9a31"
    sha256 cellar: :any_skip_relocation, ventura:        "3ebea691938a70d61d0403196579866ae1f56e33280a6db41bf8e7c9f5a4eedd"
    sha256 cellar: :any_skip_relocation, monterey:       "9e8eb43270dc11f7d98369d16100f4de241fbc17ac75ab8e38039c7c25be784d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c91e6953e56f73ad0492d6c79489e4169fe8124fa77e7d729841ff297874d61"
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
