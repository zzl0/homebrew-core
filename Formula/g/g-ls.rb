class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https://g.equationzhao.space"
  url "https://github.com/Equationzhao/g/archive/refs/tags/v0.25.4.tar.gz"
  sha256 "e65b805911aea06a5de65cddef6ee3c43ae755b4b95e930fa9461a336c819647"
  license "MIT"
  head "https://github.com/Equationzhao/g.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9adf2f93fb6cf0973014a23c0545244e1b7acba3810c21607f5ec0b5f8b8c828"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff7a56b0a2824cf59fe32f1d6205830b1119b65a9e41f085d843bd2acafacac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67eafed85b81ce927828a8770c3a4a1880283bd5eb1f3b009dca4f3c1d600074"
    sha256 cellar: :any_skip_relocation, sonoma:         "8090ead61ac4906ba059ee4a225c8e1261e7d3b41873320388325aae5ef76438"
    sha256 cellar: :any_skip_relocation, ventura:        "8cdbf850c14ab45ef1cc286f9bbe34571fa632a9e78fd5ad678553ed9d39eb6d"
    sha256 cellar: :any_skip_relocation, monterey:       "11e9f71ed9b5acd8332f6c11fa87e76a686c196a1dbc15e059a5187fdd7402a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e1397bf97ee67aaa62e94eaa1238859e2d3c86a08c311b1c01f471be862785d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"g", ldflags: "-s -w")

    man1.install buildpath.glob("man/*.1.gz")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/g --no-config --hyperlink=never --color=never --no-icon .")
  end
end
