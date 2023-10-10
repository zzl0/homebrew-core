class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/refs/tags/v3.17.4.tar.gz"
  sha256 "97f5d29dd6eeddd1abcf79b3e1a47472290b5b4bd72e2dd730bc5b997272c10d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5ddde075ed2ee29858dfce08d69f373514c5e753f60b5afae3f82c007da8a58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a82f2bb8cfa6024bb186d7c11f2acb5cc7444a0c54ec86b38224d8bc1e77396"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca37fa802bac18ae3e9891749cea70de3333050efbfb1f9fab4f5f6a8c8e1b47"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd92eb8bec7c92e5b362eef5b0d7f0f644ff4a0c35758aa50ec8c30929a8776f"
    sha256 cellar: :any_skip_relocation, ventura:        "6559dbdc99972309f36be422cdb5685628fd7e0cb4033cd3a3c3faf21f808ef8"
    sha256 cellar: :any_skip_relocation, monterey:       "030195632dfc1032e253bd10f3061838100de4a3f784829231e489ef79c1d3f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be7f6ef78f75a5d58855d155497e7c76191f04145c5c7e90d5d0fbe8aca96b59"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
