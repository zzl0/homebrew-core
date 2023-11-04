class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.6.5.tar.gz"
  sha256 "7e1c28f269c9c9dd0e794937d760d19bd552f497501ba84321ce2325eea7d496"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95c240d070a0f92d8dd52a2e6ecd22e11da5c3444d3d52d432f08aedeb018b8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d197e9a43cdf9b165710e33aab3c928943fbcb2a30048e0c96a543f54ae1de4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d0000aa8484410abd6c126077ec82f7b543c910f34a727cad62788801f01f53"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4259024ef2c89987fbefea352471f78f23227d9990411c128a4cf9ebb311b8d"
    sha256 cellar: :any_skip_relocation, ventura:        "eeb7df8a260fc8155366691257683720f96e272334ecb9813e6deb31b3ae79f5"
    sha256 cellar: :any_skip_relocation, monterey:       "00415cadf3daf62a77727d2d3b2ebcbc355b50bace2d8e70bfdc67e84ad8ab45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daaabc5deb57abf3a50466e064f905f593d264af7503f97821206f9621862c42"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_equal "[]", output
  end
end
