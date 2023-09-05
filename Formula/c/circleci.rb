class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.28995",
      revision: "636da775cb1afdb288282d6fff4a87cbf60e10e8"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2977ef886499161dec7dd1372c61dbae4ae01ebb51457ed6d3a546e0f7f53436"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5dd2b2bc620014c418918a430ad3cb1dd1c4385e2e9e04fbe0cb70f69c4a96c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b3790209ac1b03c37f6de51d16d3cf45873ddb6d602f7e971f6e30eeee3ab0a"
    sha256 cellar: :any_skip_relocation, ventura:        "d319f47064a80e87860f677cc756c0963f6531964f339abc479834d307d937ec"
    sha256 cellar: :any_skip_relocation, monterey:       "cfcf358eaf0db3fe1467385dfdc42766b2670baaebde8152add4705dadbaf181"
    sha256 cellar: :any_skip_relocation, big_sur:        "142a021656bd3a2d1c2c61aa12287bf68a5bca220fcfa4cd61a98b8b2ce313fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d55fa8f949f411107284d1446a7a270cad95afaa40ab35ea63fc4a3537a42c8b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    ENV["CIRCLECI_CLI_TELEMETRY_OPTOUT"] = "1"
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}/circleci update")
  end
end
