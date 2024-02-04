class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.67.1.tar.gz"
  sha256 "0189700c94702e20cd15cf63b0f6b4afc5ff97e6e395cc2423ad2ea52927fb0b"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e42c6f21ca4ea1306ee56c18b5f23c8e71e98c6fc892c09aad7453fedb71159e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42586b43ea4a5c9872f1d9a6e54f0148a7cabfbb1453165649f984bef3ada6bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7636bd3123fc024f2fb1bbad9eefd8ee398f13182c43d175a4017d6a76e68d79"
    sha256 cellar: :any_skip_relocation, sonoma:         "93d950c750765f5a37cb5ae33d247bb141937f4c6840145dd1e3615211d6539e"
    sha256 cellar: :any_skip_relocation, ventura:        "22e654225c6fa6e5ea38e6fd783344bfbb0ccfb5432555240383b2c9fa8d5f0f"
    sha256 cellar: :any_skip_relocation, monterey:       "835160d9693bc99cd8a2dbb65c5dc755766e6b42c40b23a0021b5f7400dc322f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c76973f761c0e74953415ab93d0e55c729739febacb2e5b2912a00a7a0ea045"
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
