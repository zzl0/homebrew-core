class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.12.1.tar.gz"
  sha256 "dbb189eb7eef79587af8d93b53186d76df74add485eca7d9ea1e0ffd66207502"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd8e1ae918b63dc150f1238ff6c0b1f7d4de7329c7314a8df26b355bde0ce7ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "632d251eb517cfad46822559fd557d050d91e369f459f3d56b0c75fb4fb0daf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34c0948106fc1130e9d9b1a8584a302eb2f304db3168c396bf8a373f3171666b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bc8b732da967cacbe6e7d669c78b4e7a107b4558c8a79e706841c2ca221f796"
    sha256 cellar: :any_skip_relocation, ventura:        "fa99579144b072316f528563c5e2e77015dd43f36873d2a557f9a261c341606b"
    sha256 cellar: :any_skip_relocation, monterey:       "b35d3e06564b6dcc7100293d673ed35c06e8f92edea249142b7af344d39a04cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af9ae44b2b768f96a86bc8a28a453a1adfdf8ff16c140e1684d8e84bc4dae867"
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
