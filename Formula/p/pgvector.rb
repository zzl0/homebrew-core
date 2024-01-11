class Pgvector < Formula
  desc "Open-source vector similarity search for Postgres"
  homepage "https://github.com/pgvector/pgvector"
  url "https://github.com/pgvector/pgvector/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "cc7a8e034a96e30a819911ac79d32f6bc47bdd1aa2de4d7d4904e26b83209dc8"
  license "PostgreSQL"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d0976826d4c49e76a138ee3c132e113035c18a678a65c485d62eee6609fad66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b5f0ef0a13a2aadd8b91bff83adbf3a4e178d35a47b31e6e2a44211b03e30e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c1d23af66832d810132b02e4f8e1ef9a418fa08feca30db02e8ea4c71c0dd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "51d124f27e7bea6538799b17802f62b2aaed9ad64c0f7f492ac692320fdd4918"
    sha256 cellar: :any_skip_relocation, ventura:        "1e2abf65b3dbcfbd141f79f9952fb289e6a64de6d3ebd524aaba876d22dde087"
    sha256 cellar: :any_skip_relocation, monterey:       "ac522f57c063ed96d2b5ffef87488fd61a7d68fbdac536260ddb3c0bc8dbf229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0724750eaedf54c546ccc75dae7613cef15f773bb189eb531bd5bba00f1732a"
  end

  depends_on "postgresql@16"

  def postgresql
    Formula["postgresql@16"]
  end

  def install
    ENV.prepend_path "PATH", postgresql.opt_libexec/"bin"
    system "make"
    system "make", "install", "pkglibdir=#{lib/postgresql.name}",
                              "datadir=#{share/postgresql.name}",
                              "pkgincludedir=#{include/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_libexec/"bin/pg_ctl"
    psql = postgresql.opt_libexec/"bin/psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION vector;", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
