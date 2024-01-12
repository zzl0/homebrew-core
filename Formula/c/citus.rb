class Citus < Formula
  desc "PostgreSQL-based distributed RDBMS"
  homepage "https://www.citusdata.com"
  license "AGPL-3.0-only"
  head "https://github.com/citusdata/citus.git", branch: "main"

  stable do
    url "https://github.com/citusdata/citus/archive/refs/tags/v12.1.0.tar.gz"
    sha256 "cc25122ecd5717ac0b14d8cba981265d15d71cd955210971ce6f174eb0036f9a"

    # Backport fix for macOS dylib suffix.
    patch do
      url "https://github.com/citusdata/citus/commit/0f28a69f12418d211ffba5f7ddd222fd0c47daeb.patch?full_index=1"
      sha256 "b8a350538d75523ecc171ea8f10fc1d0a2f97bd7ac6116169d773b0b5714215e"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "17326cd59837094b9bfbc6d9ff5896b25499bce16bb574c735954c27a05b8cb7"
    sha256 cellar: :any,                 arm64_ventura:  "a5baf03c959fbef16bfd4574f66a0c875f8f63693deef6b8f733ccb5da99dcba"
    sha256 cellar: :any,                 arm64_monterey: "39dbd80b36a184b4d2212edba926771431aa29b4808818509a3c2a5c6920fe7d"
    sha256 cellar: :any,                 sonoma:         "d69701ca154c1b9dda7c64db6b3f9e71126238c0c1af97080bfb667765444d80"
    sha256 cellar: :any,                 ventura:        "d1074ef6010dd8a10aa2d4a8ab089631a3c5d712e392a706f613125ebb0eea1a"
    sha256 cellar: :any,                 monterey:       "42e65a865e1211766e2a9c64aeac6cfc0b1960dcff6bb7aad542da976ef18da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a578130355c16b60bf6e59265acf3223ce92bbfa4aed3d9d8f129157aa4939a4"
  end

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "postgresql@16"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl"

  def postgresql
    Formula["postgresql@16"]
  end

  def install
    ENV["PG_CONFIG"] = postgresql.opt_libexec/"bin/pg_config"

    system "./configure", *std_configure_args
    system "make"
    # Override the hardcoded install paths set by the PGXS makefiles.
    system "make", "install", "bindir=#{bin}",
                              "datadir=#{share/postgresql.name}",
                              "pkglibdir=#{lib/postgresql.name}",
                              "pkgincludedir=#{include/postgresql.name}"
  end

  test do
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_libexec/"bin/pg_ctl"
    psql = postgresql.opt_libexec/"bin/psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      shared_preload_libraries = 'citus'
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"citus\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
