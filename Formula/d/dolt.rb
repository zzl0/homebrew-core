class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.30.7.tar.gz"
  sha256 "51242af36263379a90567d1c1fe581ada4a268e0057859059d8254fef3585b81"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19c6fc6af2e41d285bfde454c0702b59ef5d41582167b03a483a24f9117fb307"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51e58fa6a19147b16d588de6a04e228e901a34eb56f309f630f4e8af40e26acf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48bbabb58fe1cb69d3ba282b446c040e1fa459868594a4b6ce595b77a06839ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "c04a19b13b4e8ec80868a0924961c265588826905987a22a17f1a1658a149238"
    sha256 cellar: :any_skip_relocation, ventura:        "4adf6c03ac4ef56e8d5d05befc80d16fda212f673734f01cbe3c303cc25a8d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "9a15910add152118b8adf216f9ca6d50a062c0838daa462244f9bc64cbc5a698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "364221c81ca399481932226723cc0a2246cc3a5d2b76363078366b961a7b8f5b"
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
