class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.74.3",
    revision: "bdc6fee5e4c7c4f0fade19e61564888dd112674f"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3393679058ab51c8687a0e8aed400cd091ac57a667e51287311c07f9b55ece36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee5b75db0310b18eb3329fd7099be5fd3b8d12ed30f956933e4cc2a45c510868"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c3c6bc8c314b171725b67209b0618750920b371be74a4900b35d59b22e8482a"
    sha256 cellar: :any_skip_relocation, ventura:        "c59d9d80ec98b5faeef4276c7ebc9864fc1a8c1c06249d4848bab24f5cab53fb"
    sha256 cellar: :any_skip_relocation, monterey:       "2f547f7f2dccdb95119b5e1c88b05a420edba590663895463b4c232d32404c24"
    sha256 cellar: :any_skip_relocation, big_sur:        "040a2cb7c998dc2b3c2b216d85ce650c3aa162f355f903e578b06f8b1a34bf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25696785f07dbf40dd9c5d9b3f11900a9e0e4f84495b57ce2484042f0e29db9c"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
