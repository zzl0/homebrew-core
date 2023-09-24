class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.9.tar.gz"
  sha256 "7097264e7da0e7ac209e5be5e50f07f17593e2753607325870131af3000ccaf2"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e92682f017d695208a4a61d0b7ffa35a17275b66fe4becbcfa0634bde9e3d31d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e92682f017d695208a4a61d0b7ffa35a17275b66fe4becbcfa0634bde9e3d31d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e92682f017d695208a4a61d0b7ffa35a17275b66fe4becbcfa0634bde9e3d31d"
    sha256 cellar: :any_skip_relocation, ventura:        "c0bd9a6dbca748dbbbc2d17e3259d710b1feb5e5d553b17dfd76d35d4f25d3c1"
    sha256 cellar: :any_skip_relocation, monterey:       "c0bd9a6dbca748dbbbc2d17e3259d710b1feb5e5d553b17dfd76d35d4f25d3c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0bd9a6dbca748dbbbc2d17e3259d710b1feb5e5d553b17dfd76d35d4f25d3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d636a582dde77907c04d604728b2a0b1fd7cc84065b2c3f412920267c398a4cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"s"

    generate_completions_from_executable(bin/"s", "--completion", base_name: "s")
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
