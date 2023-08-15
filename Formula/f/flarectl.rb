class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.75.0.tar.gz"
  sha256 "b133c90f97ccb90a7f3b7d9e60547b67a384a038702c8854f02975f67315e5de"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38ef6bf8328da917525f2b18941263bdeb472102d7a692e4f62e728a9d7a149e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38ef6bf8328da917525f2b18941263bdeb472102d7a692e4f62e728a9d7a149e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38ef6bf8328da917525f2b18941263bdeb472102d7a692e4f62e728a9d7a149e"
    sha256 cellar: :any_skip_relocation, ventura:        "69c017a2dd9200f249e0516a1878168d9441c26967638e1e44fb2834401cadfc"
    sha256 cellar: :any_skip_relocation, monterey:       "69c017a2dd9200f249e0516a1878168d9441c26967638e1e44fb2834401cadfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c017a2dd9200f249e0516a1878168d9441c26967638e1e44fb2834401cadfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44099370c56e0a608df1b97d02bb987197b14ab3d44626a6f3e3132a9339715b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
