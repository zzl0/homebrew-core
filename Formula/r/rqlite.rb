class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.0.2.tar.gz"
  sha256 "6df285053943f09ec47a3b936b33651ea9fde6f31e9616313a65999d86b0ce5f"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "787b7710f7ded53fcbbf44f1734ff75fce9041981d84f1883320d0218f7fcb40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6b1b22db8e8a4b29b3d21fee7183c537a7a06f6533125ff38b976c040c14d18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "060d1c03eeebd21621646cfa5da5df2dbd77177a1557560b6bdd819d71998e72"
    sha256 cellar: :any_skip_relocation, sonoma:         "676f783c1a4ba42431aad18aebb49b78f98feee1bf8cd025a3c23d8b30fe980b"
    sha256 cellar: :any_skip_relocation, ventura:        "b53fb54e2f693d644622cedc219e07e330daa55dcabff85bbc583d81eab66a0b"
    sha256 cellar: :any_skip_relocation, monterey:       "baf70ba211e911aae236f547859fe664a215da27775ca9b0253fd1d9eb6ad3ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffad045d6a02df76d7891ade83d56cfa44a20748f0577b6c859f1e27937f7cce"
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
