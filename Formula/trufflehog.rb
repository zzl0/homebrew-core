class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.46.3.tar.gz"
  sha256 "803ec325f83756a36cd0f0449fb07b89e9d38904aa86f7375f347059e1fb3224"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d642c6dbc4b172f2e0b403b40d95ee2d137093fd8878299ba8107ecf073625c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6030adf05cb92e8e369b3e14742c7d48c6fde19ae4b301838f79b8948bde3fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f554846b784ae3703c7c641af1a14b7601a06574f106aa1b4282edf6afbb78c"
    sha256 cellar: :any_skip_relocation, ventura:        "7e2d673902102e863a5bcdc9975b07ce3592839d823eaa6fb1550d1131a63298"
    sha256 cellar: :any_skip_relocation, monterey:       "c055e77fef098b349afba2ad4a799f7ec7a80fa404fb080ec8ca9b1b2b9e1a69"
    sha256 cellar: :any_skip_relocation, big_sur:        "b70d588ef034403d62ab3a82f8a23913f055880c660f33f44b6c068179b543a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7995ae6e14c3f7c8fcdb5b1cfc0c31f773b8e71d64d1e9067e352eb37bce9f0b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0}"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
