class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.11.0.tar.gz"
  sha256 "302d594d672c758e2bcdaaf551487432bc7d1f85af2bb9296a75cc0aa1ed5173"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e69cbed08bc5b212d8813bba704d251111a15fbdeb21e3f20cdb18d7342546f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f39d732a229eabed5c1823180a7c983c28f77d55c20f809293ede3f3e16e92a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eabb1461b4c5666b5c06ee777027a6345c1de3c07029dad0682372d2b3a963d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cad38b00167b57f59efebcc6ecad49503a85d74c663497e067dbc36c600e36a"
    sha256 cellar: :any_skip_relocation, ventura:        "ec16ca1fee4c3377b4bc3a922f4273608ffc8afedf95fefd25b410faf1880ff5"
    sha256 cellar: :any_skip_relocation, monterey:       "9f156cca7af6f583b2d79deee58e98810b06e3f89b3b69765840b602c57c2946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d321f8a9e057df56c2535dffe252b591dca54b47025fe1b04d9ab3da5d1228ad"
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
