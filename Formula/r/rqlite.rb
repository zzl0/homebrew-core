class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.13.2.tar.gz"
  sha256 "5fb6aae8f5649c028d30337bd9c79fcd68c66f2dd2f333ff4167925d5582e63c"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd94c71ba315e501b52586db75ef75511d0bd83630e8b740e0be95c4f7cbf742"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d7ad9d30a420c23a235a3e04682d24e2a448d9aa6688adbf59384bbcdeae7f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc621d02eff01ce154462e90bf0733bdec4048786e4a21daabae6718a9b18fe8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c194d9ad91025477145e79ab4db2f2d048fb28f2870c83048bddbd5c182bb7c2"
    sha256 cellar: :any_skip_relocation, ventura:        "1f000fb066bc69c9543bb5c08313ffdb6d47ad7ca7ba049738ae379d3f4e85be"
    sha256 cellar: :any_skip_relocation, monterey:       "e547eb3c9cb0220c392d45ff5885367e9781064119d8cced6b0a03b53408088c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c8b004fff88f5d9930d66279b6b79ffd717fc6e77cf48a53face3889b03598"
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
