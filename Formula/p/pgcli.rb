class Pgcli < Formula
  include Language::Python::Virtualenv

  desc "CLI for Postgres with auto-completion and syntax highlighting"
  homepage "https://pgcli.com/"
  url "https://files.pythonhosted.org/packages/5f/2c/f0d4bae5a9ba6d03c959fcbf1e94daeed268991671ee2e8b7b55dbddc7fd/pgcli-4.0.0.tar.gz"
  sha256 "0bf5f8dbbc9047e0646d016a421328a260c46cff2108908b11bb55c96475ee8d"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d331c62de6055634aa7e32f6796b9e216868c42ed4444290c6755436413f412d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0c1bd3cb3411d770d00787985c31d3bc967a231fcac021142c2e72a8889e578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bbea1d37a2b83bcf14fdcf1f357a08a1bb2e10d630c7cd71bf438e58a4731c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "adfeb0b4b4999c11084378aa6f4d95650d6a6f5adaa76fcfc839118d1ce574db"
    sha256 cellar: :any_skip_relocation, ventura:        "893cdbcd80ab264689e0bdf527378f6c668c98aff7964a0afc7167458469a15a"
    sha256 cellar: :any_skip_relocation, monterey:       "dc94343f65e6d50ca658ca37f940329d18da8c1865cc1224be192124cca0e993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d2b2a793e14bef7261d5a25bc0e6045a6843caa5ca14d64c3951db8101d18e"
  end

  depends_on "rust" => :build # for pendulum
  depends_on "libpq"
  depends_on "pygments"
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/50/8d/46fb2d097947b2c717475c584247e47f635e5524ff8b227f18e991e7057a/pendulum-3.0.0b1.tar.gz"
    sha256 "5331e3106e9a5690136daf386ac78a7c7e47bd4b777b8dc8925b608633788718"
  end

  resource "pgspecial" do
    url "https://files.pythonhosted.org/packages/2a/77/93b39f02da1acd73fe8d775329b7fdd4ef394101c6e52f6ef715f8fe6003/pgspecial-2.1.0.tar.gz"
    sha256 "099a9c43b5768885a99c761b1f14a8c6504bb14e9631ad8755739adaf758266f"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "psycopg" do
    url "https://files.pythonhosted.org/packages/42/30/73ebc6d40269fa4fdc090c374d1dd30df822e885a742719b0fe952c9d86c/psycopg-3.1.12.tar.gz"
    sha256 "cec7ad2bc6a8510e56c45746c631cf9394148bdc8a9a11fd8cf8554ce129ae78"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "time-machine" do
    url "https://files.pythonhosted.org/packages/48/50/d0c443bc1287dc20a22597346864175774d39f40239223f95fb03d70a044/time_machine-2.13.0.tar.gz"
    sha256 "c23b2408e3adcedec84ea1131e238f0124a5bc0e491f60d1137ad7239b37c01a"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/70/e5/81f99b9fced59624562ab62a33df639a11b26c582be78864b339dafa420d/tzdata-2023.3.tar.gz"
    sha256 "11ef1e08e54acb0d4f95bdb1be05da659673de4acbd21bf9c69e94cc5e907a3a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")

    # Help `psycopg` find our `libpq`, which is keg-only so its attempt to use `pg_config --libdir` fails
    resource("psycopg").stage do
      inreplace "psycopg/pq/_pq_ctypes.py", "libname = find_libpq_full_path()",
                                            "libname = '#{Formula["libpq"].opt_lib/shared_library("libpq")}'"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install resources.reject { |r| r.name == "psycopg" }
    venv.pip_install_and_link buildpath

    generate_completions_from_executable(bin/"pgcli", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "Invalid DSNs found in the config file", shell_output("#{bin}/pgcli --list-dsn 2>&1", 1)
    (testpath/"pgclirc").write <<~EOS
      [alias_dsn]
      homebrew_dsn = postgresql://homebrew:password@localhost/dbname
    EOS
    assert_match "homebrew_dsn", shell_output("#{bin}/pgcli --pgclirc=#{testpath}/pgclirc --list-dsn")
  end
end
