class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "4188a628483f23e5a6845020fa87faca0514a812ecada4899bd31d2d39e8a4cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e5ee69e2fa71ef3e5e22274a3781a3d0791639364adb645d3f82207db2b3b9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b9221c2a2597898b75be9e13c1e10910cdebc1567284f9005ef5a88ec4d8ac5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cee5ad299962c50e43d84d9c9780d9f8627b0c5fb3498612af68d3f68a3958dc"
    sha256 cellar: :any_skip_relocation, ventura:        "d70730d44e91e128730180763e5e7da70a3946209855f14bb0ec806d8ee97270"
    sha256 cellar: :any_skip_relocation, monterey:       "77ecd7dfea20b32698c13b669b739dd20b0ee3ac83058a2a25498a177724432d"
    sha256 cellar: :any_skip_relocation, big_sur:        "be5351af1085f9b1dc73f3532e237f368a4f7cd56674f2a3a49e3aeeb131856c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a311d39685a0047d0739560cd3a18447ec5cdd1891ff238165db134924bbbd"
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
