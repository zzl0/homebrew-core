class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "b90cd4eb851616acd451bf2f53c80a1a103316b8e035083ccc1cd4aee570b10d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d22ff8aa6badfaf660c4ba3e83005861e570a6e417fd5dfa45aab3ba6eccd8db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66142e62c7e75005d07c8bc99720e0d1fb9adf4d34583838ffea3a928c34fdb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7e94b928fb64ae011ccc0cf20c88b4129b445c4251fc9d019cab557a3cee7e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c47686965946d7413ec72c146848babc8fe04ea65f344b3e60f7b5d414f5f4a"
    sha256 cellar: :any_skip_relocation, ventura:        "2be4813f958c57e511cf79eae52649f8e411e0b90405f5296907c6f5f60698fd"
    sha256 cellar: :any_skip_relocation, monterey:       "f889133bc28925136ced448bd19988976cc8e11551c393a2a9d356d9010ea163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "052a7b5ad18488799db38a0650f5512bca631018474f973e4a474403404991ad"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
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
