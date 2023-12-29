class Doltgres < Formula
  desc "Dolt for Postgres"
  homepage "https://github.com/dolthub/doltgresql"
  url "https://github.com/dolthub/doltgresql/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "6d2458306755489f84ef6ac78bdf58f090511d2d3b099c3ff429a04daf4be024"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  depends_on "go" => :build
  depends_on "postgresql@16" => :test

  def install
    system "./postgres/parser/build.sh"
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"doltgres"
    end
    sleep 5
    psql = "#{Formula["postgresql@16"].opt_bin}/psql -h 127.0.0.1 -U doltgres -c 'SELECT DATABASE()'"
    assert_match "doltgres", shell_output(psql)
  end
end
