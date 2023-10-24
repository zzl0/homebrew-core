class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "7d740d6c5305c405861e83878f0d955c8e415f2eba5ce7b5669b4016d5371d79"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd03ec7ded0869f281a5e2c8f7b65c6eb5e13543f03068d6260f257832689ae4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dcb03570fb96bd4cc1ee1e3f3df76cb38acac0e1d0f0b3b3f7ad902443fd89b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2acd61ac9e45a6382df79bcbaa0b5203a75b87b4de21c4e2ce4342db8798a750"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c894a39fd342004a3c668f8453843f372e1f19b6741b58acb94d54ea7db8e14"
    sha256 cellar: :any_skip_relocation, ventura:        "6851615babf2f0e1abc379f59901897cfbc0702d884710f1c89f96029612ac88"
    sha256 cellar: :any_skip_relocation, monterey:       "d08a63a550b8b45c262d803ec2065a2cd15f3e60aa1e8e057da75d17689be926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d857e9b0fc71d8074163846b5a7e5f8e583a02ed84cb00f7760d501d0b0e7cbd"
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
