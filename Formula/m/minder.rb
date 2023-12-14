class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "cf4679938a37d64a1c9e16bd9862f7347ac532a8b8254f780508bc692460ed3a"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ea9556d0a53fc23c3c9c9bb89b733065ac41c0b77e5828a7e9b4cad5598dcf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "996e3e2075686088710416572f10a7942bde6c3dc37ef66fb5c969b471e73de7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39a12ab3df3247f4a67b7f6b37e473634b8fc5bbcc506a2bede3b62a55b53e60"
    sha256 cellar: :any_skip_relocation, sonoma:         "32af5bde3a741758854a5dc179a533c1ff47d04bd03e5cdcbcb61fe62e4da412"
    sha256 cellar: :any_skip_relocation, ventura:        "f4a663623a7e195830afa9eec6d14d5652669f7ef48f75f46c63138ade63ee0c"
    sha256 cellar: :any_skip_relocation, monterey:       "57a70e952fc80d542dab1a62b48c0847396e2f7d6da89635e43d7c8d0b7cc5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff6ff06c4a4bda1e993f6eef5297afa8e27b56c901bba4f1a78ed0e840188e2d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "Details: Unauthenticated indicates the request does not have valid", output
  end
end
