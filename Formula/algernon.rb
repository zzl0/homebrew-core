class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "38dfdda60b0a29d0c22b8a2b0ad549b66d554d1e4f076c76722b532aa281d2dd"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b4ea9f9de0d82962aa894bbac4ffdb7cc9687875213069c71d986e7f59f3e69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b4ea9f9de0d82962aa894bbac4ffdb7cc9687875213069c71d986e7f59f3e69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b4ea9f9de0d82962aa894bbac4ffdb7cc9687875213069c71d986e7f59f3e69"
    sha256 cellar: :any_skip_relocation, ventura:        "f7f7b14df747ef14f9ed34b8b2877e38b4badfdf6396b10c552c70210baa6318"
    sha256 cellar: :any_skip_relocation, monterey:       "f7f7b14df747ef14f9ed34b8b2877e38b4badfdf6396b10c552c70210baa6318"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7f7b14df747ef14f9ed34b8b2877e38b4badfdf6396b10c552c70210baa6318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a48302edad583fbc5d4eb4f2d94805d5bf11b34fa4d14b2feb004c17c9598e1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
