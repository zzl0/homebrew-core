class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.24.2.tar.gz"
  sha256 "83d5d8d3eafe35b0b7493fea26aa9caea0958dab96528596da63e58dc32ea3b5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fa10b937f34f51c5dc9c9ccd905170e47043cc66bafd7996f567664049e89b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86a15044fcea4540365249cc7f9aca976ba5bb7ab7bc0b099223552c770c0191"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7326201cdf5dedf96301b0e41f4bfb567319cdf12fe13f82edd4d11231cbb65f"
    sha256 cellar: :any_skip_relocation, sonoma:         "451ec1067893a62e45502b662d66c1b8d2ad6ae356796dac558337127e6b7851"
    sha256 cellar: :any_skip_relocation, ventura:        "7bbc9a4985524b8bbbfd72f7ef9834e96c3af676bef2846239fd8dca56117186"
    sha256 cellar: :any_skip_relocation, monterey:       "48c1bcec87977db0283738fb1800e15db7a0458bdd964e0004525865fd2d3795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78175e8934f6d6d1b755be37f9bda08dd0da3a5d50a922a307effdf858cfe5ab"
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
