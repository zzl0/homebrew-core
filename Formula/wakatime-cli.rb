class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.73.4",
    revision: "3f10a7d868a647b8d0bd9717373745dee4a380d9"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c981f04d826015ae88fea74d0da31112781c3cb29facee4a9f92370a7be3fdcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c981f04d826015ae88fea74d0da31112781c3cb29facee4a9f92370a7be3fdcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c981f04d826015ae88fea74d0da31112781c3cb29facee4a9f92370a7be3fdcf"
    sha256 cellar: :any_skip_relocation, ventura:        "35d49982bf2a861bae0005bcb1dd01ac755d3ddbb4c2f9289bdc47496b77bdaf"
    sha256 cellar: :any_skip_relocation, monterey:       "35d49982bf2a861bae0005bcb1dd01ac755d3ddbb4c2f9289bdc47496b77bdaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "35d49982bf2a861bae0005bcb1dd01ac755d3ddbb4c2f9289bdc47496b77bdaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdc530f8e0437c7bd6258fc5eba791335ddbfcbe184824fb04a85940a4d53451"
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
