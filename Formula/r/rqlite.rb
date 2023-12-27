class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.13.5.tar.gz"
  sha256 "2a395779b703bb1dd6faab550a3fab99d082c37b13e685ed83f5309d62ae7e5e"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "971508ff32c83c3516d5fce7bbebbd74213a7127f52a0f789dda31dc90d542f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef25e657fd58a8f627403649520d6cf21f0c2b12458a56e88c2f1e0246f104f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98a62c7ffc4a733a4bb72d79d3f263b5d5f7c0a7c0dea8b3cdf9f315b95e9d77"
    sha256 cellar: :any_skip_relocation, sonoma:         "35dbd45584af7c12e53c9e9cf580fbe1ab00251b123cd52852877ef41013decd"
    sha256 cellar: :any_skip_relocation, ventura:        "983c76a5954c7188ad4fcd482d35b0c1317c3122b305b63ebeaa59e166cb29ba"
    sha256 cellar: :any_skip_relocation, monterey:       "efd1b3e55c710700027935b2d0d2895e314cac80f33d4454ab9fcb8db2c568ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920342ab630c652934d80f55057494223f651e3f255ca0d680e9ea4564746ab4"
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
