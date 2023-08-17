class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.51.0.tar.gz"
  sha256 "93cc8deb6c42c04ce1fedc522d2799eb0f303b357e650bba7bffdb0c07f85203"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd3957a97c027b278f6346dbcec5dcb8909afbad3dbe8ab75ab64f1ad5ac1609"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad97ae1701c173838c066e596d11b28f0a81b6951a9c84b488597d9b2153191a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba96c07a80dd7ef1461527e54dd59da8b58b6c480e005ea8980f55b59aeda15f"
    sha256 cellar: :any_skip_relocation, ventura:        "0128d16fef574324118b67c23a9e1ca8922ba93fec52d2b0b8bbf92254c43a07"
    sha256 cellar: :any_skip_relocation, monterey:       "4223b538e75ea08402a6bd586b48f8d9cc0bee0ee9bf37f850e265663b309e04"
    sha256 cellar: :any_skip_relocation, big_sur:        "ede18b89e9a6f125a27d47709ce47dc0331d2496a55f9e5c71dbc489463c1e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3caf17a0dbee1f86720c5cdc2ed138245823dfff72bee28e0f8df1a032a94303"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
