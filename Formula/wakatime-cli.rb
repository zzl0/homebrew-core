class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.74.0",
    revision: "3fa4ea943973200b11f00b550b3ec30cebd9c4f6"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bab15cb8a36f2df2f8391f09125d0d485714bab7b95e8aea7d13901adfec83ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bef53afbc8980c98efd2cf5f244c81553c2f71ef5f5bc05e2425344fa6059da3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "386c85075fc83fdc15c8f519a24aee0691e85afb72cf8c2d50c8a9ab6a3cffe7"
    sha256 cellar: :any_skip_relocation, ventura:        "5918cc66e5dbca91eb6d2692a19accc32d8e934c622a2c6edf46a5e11bd1bca9"
    sha256 cellar: :any_skip_relocation, monterey:       "bd1ed9929886a2c2521482f444489a1161eda14ea87e7e435cbca2cc88d7582c"
    sha256 cellar: :any_skip_relocation, big_sur:        "40bbdd5086c4b210c8bc621c8100eb94cd8e55a490b219e60efb314ada7fb88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "683573bafc1f00068729047b59a8e3bd8ac9937e815a845e210a1d84b29dcb65"
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
