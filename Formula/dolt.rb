class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.8.8.tar.gz"
  sha256 "20ea7519d682ba2d2a24e8d8a9f964b46b38fa81a0393da4ca7c634229f71c8a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cf72a3c81cb63a86ec1433593de8b76a69950b37fdfb0e8fc1cfbcf8ba49763"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cf72a3c81cb63a86ec1433593de8b76a69950b37fdfb0e8fc1cfbcf8ba49763"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cf72a3c81cb63a86ec1433593de8b76a69950b37fdfb0e8fc1cfbcf8ba49763"
    sha256 cellar: :any_skip_relocation, ventura:        "dc77f3b5234efba2c0cc6637c686613c246f38afc393cc90b7cbf758fd1ec33a"
    sha256 cellar: :any_skip_relocation, monterey:       "dc77f3b5234efba2c0cc6637c686613c246f38afc393cc90b7cbf758fd1ec33a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc77f3b5234efba2c0cc6637c686613c246f38afc393cc90b7cbf758fd1ec33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a2e38efaba8c633bf4a81745d7bb69f2a0be9dd13ae3f4480f3d8b38846b808"
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
