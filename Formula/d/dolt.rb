class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "2643a3200d24393bc6407f92cba76793aa18d6bc0a4d91c0fef6b36b08639100"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0754e6d30e21d6c5df28d49c3388b82c70802dd81c6b573f9b34dfda07a79d86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eed395129a1352f5e00afffb1ba9fd236d2778d5e485a856984970f9196966db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c5eb1e71a57b67bb4cb5e7bbe54b6f3e674b5b17e14cf6af0abd4594c7b6aff"
    sha256 cellar: :any_skip_relocation, sonoma:         "697f7dc126a47ff3b397759030c75a767733bbdabcb1f817aaa1fb23ebd3f584"
    sha256 cellar: :any_skip_relocation, ventura:        "67a65f405e03f2f8e4576ee387bad4e135d55fe99f3d278ba8b41708ac7817b8"
    sha256 cellar: :any_skip_relocation, monterey:       "4b11c14c9e2ccab10f3f77f328ce605385f680e2739d380d474f6d61778efe5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aa4fb5f15956fdc8e000960efdbac7756b73b41b49643a1309acf3458da9da7"
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
