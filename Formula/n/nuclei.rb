class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.1.9.tar.gz"
  sha256 "a34932f0f17daebe2f7d32be50b643f19f8523e2f800d7d881a03a7ed491a11a"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06508f76aa7b3c56829b8020bb96b0ff53742bada1ef8b3d9553cd06caf3b458"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa19e26897290bb06e472f52c477ae5e983b44f299cb55f6332f63722f7fb5ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6b8dd0fed953ac05f3c07af4053d419e4a7f190b1f87c1c48e30775e099cb0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4721cf697776fcc8791d71c78521b934972db80111a5ead34ff37153f5e9155c"
    sha256 cellar: :any_skip_relocation, ventura:        "b360f9aeada73da2c4ae6b4f6356d56cdabf151c70529938c149c992abf12fdc"
    sha256 cellar: :any_skip_relocation, monterey:       "32a9312fe280f02071467a7596079eb48c2dae31061525c4dcddba1d58e996b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed15e5e73eec56721b4e0140afa97b5b33ad068819904878255351f2b64dfdf8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
