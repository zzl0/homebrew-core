class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.16.1.tar.gz"
  sha256 "cde9b9901cd0919217437cbfb2b57c25317a08d1585d91b57eae05aacbe2d45e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c701b932075b422d53728472a0f008834c0f870878164470bddc7522554f572d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "063f8ce720557c301ef18b82d7e4bb25c772397984ff074f231dd9f6f3e86954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e7b89883d0edf4eb91c29137f2a5eaadf67ae181744dacdfdcbd8a3220054f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "55f7652dda19e4d06690d578fe17a7466ec6e10eaff07b548e9fe6233db88fdf"
    sha256 cellar: :any_skip_relocation, ventura:        "d9ce41b7eee082cc2e659f81147ebf26ef84f5d3f852dd6c4210345be38ae304"
    sha256 cellar: :any_skip_relocation, monterey:       "d201598d33f31a137f834dcaa5350fe3ce9d7d479ff432c1227ea9d4a0a6e30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc54ca63cf5f6df40cb23091dc7825e208e589f65af21e648d36bca21d1f946"
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
