class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "80230d832200daadbcc8d4042f09992a4d5fda870b44b6f3f3db1370742762e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8567e1263b0380a31507572be138250504cd711a68e71a47ec5dd8f32bed43d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8567e1263b0380a31507572be138250504cd711a68e71a47ec5dd8f32bed43d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8567e1263b0380a31507572be138250504cd711a68e71a47ec5dd8f32bed43d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2695dd04c74ab0235c5bf143f1dab56f5874fd2825785060d22a5df921c20359"
    sha256 cellar: :any_skip_relocation, ventura:        "2695dd04c74ab0235c5bf143f1dab56f5874fd2825785060d22a5df921c20359"
    sha256 cellar: :any_skip_relocation, monterey:       "2695dd04c74ab0235c5bf143f1dab56f5874fd2825785060d22a5df921c20359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a1e1bed4e3f8f7ab82710771cc8cc8311623472be04f91f1b983a14e7deb9fd"
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
