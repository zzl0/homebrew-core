class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.11.1.tar.gz"
  sha256 "49703f4b50e73f19774e14700f9de18ee2795226348c080894e013a583e61872"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cbdb2fa959cc3669e73d510edf77091d0b55fdded5778bdd1bf8bc268da43dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "491c84d2c0b34f1cc35801bb23b09b3fe772f1bdbf211ffb3526ed7f978a4a96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24dde9e3744a839c30f2306b14c3ed0b8349a7e8627841db5fba5fbef3c24ac2"
    sha256 cellar: :any_skip_relocation, ventura:        "0a24b1abce89190d1f3326c3ea3f82c53d55df61ec81499abce195343fe7dae2"
    sha256 cellar: :any_skip_relocation, monterey:       "3f92757dd083cce95651194d3e4246c19c390623a7ac152784a21541015e3e4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f34fa04cda42abd8178a816d2bda94876d33cc0469409ff78089545c1cc6929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d1ce93ab1cf966ee11755038be67c9b243d8d8a380c6feaa9f06e049b409c12"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
