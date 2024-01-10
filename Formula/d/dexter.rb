class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "78773d4d75fdba34843c89a49d4d91f8f3496752308005d965153586a091f64e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be94f7b338b28ed362c82b4b8d731ebfb3f6fd175fc98e8c7514d08583528406"
    sha256 cellar: :any,                 arm64_ventura:  "0719f4b0bb7bec319be9f86e7d22e2b0cdadbdb5473c9f76c4bd83e52bcf4897"
    sha256 cellar: :any,                 arm64_monterey: "21a8e91c98e3415a386c4c41b16289c77bd4233d1c2b5d4185754a5822fa8296"
    sha256 cellar: :any,                 sonoma:         "f4613aeaae43ac94f982465e783219f6c8329010c1821de3c8ac13c8c5557c36"
    sha256 cellar: :any,                 ventura:        "996d8f071db725f9634f0fc9282cc1dde56e4c251e9f5ac20b0859f184fbec43"
    sha256 cellar: :any,                 monterey:       "6f68fb77b162801b0dd5b6ff872207db7145994bb1cc4fa57acaf558ce740518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81868f9315ef4a076f205b3876385b98175a728b67985142a9dc6f5ee4b43026"
  end

  depends_on "postgresql@16" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-3.25.2.gem"
    sha256 "9c2e6121d768f812f50b78cb6f26056f2af6bab92af793d376b772126e26500b"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.4.gem"
    sha256 "04f7b247151c639a0b955d8e5a9a41541343f4640aa3c2bdf749a872c339d25d"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-4.2.3.gem"
    sha256 "1cc9955c7bce8e51e1abc11f1952e3d9d0f1cd4c16c58c56ec75d5aaf1cfd697"
  end

  resource "slop" do
    url "https://rubygems.org/gems/slop-4.10.1.gem"
    sha256 "844322b5ffcf17ed4815fdb173b04a20dd82b4fd93e3744c88c8fafea696d9c7"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "pgdexter.gemspec"
    system "gem", "install", "--ignore-dependencies", "pgdexter-#{version}.gem"

    bin.install libexec/"bin/dexter"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@16"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      output = shell_output("#{bin}/dexter -d postgres -p #{port} -s SELECT 1 2>&1", 1)
      assert_match "Install HypoPG", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
