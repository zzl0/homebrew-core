class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "56c546a834113493de95585d5034c3c58d42b4518787cff5450601f9d9d0e78d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e680e0951e6b55f555385c229478a51a6e63310233198213c2b3e01c204a8217"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e680e0951e6b55f555385c229478a51a6e63310233198213c2b3e01c204a8217"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e680e0951e6b55f555385c229478a51a6e63310233198213c2b3e01c204a8217"
    sha256 cellar: :any_skip_relocation, sonoma:         "a34799ffce8b6d169c48ed58619630257ccc5904d4980d1ca376312664095525"
    sha256 cellar: :any_skip_relocation, ventura:        "a34799ffce8b6d169c48ed58619630257ccc5904d4980d1ca376312664095525"
    sha256 cellar: :any_skip_relocation, monterey:       "a34799ffce8b6d169c48ed58619630257ccc5904d4980d1ca376312664095525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b5506bf2f0da8be08f91132f61caecd9b57febd0635490c43b2a9a8a6048fee"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
