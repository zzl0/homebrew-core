class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.28745",
      revision: "624523e148e4304ada6ad01ec5b55e77ebe290a7"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48a4779e587d4af0ee13fb21eb15b22a75a7dbd109bce4aec52c465930e699f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48a4779e587d4af0ee13fb21eb15b22a75a7dbd109bce4aec52c465930e699f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48a4779e587d4af0ee13fb21eb15b22a75a7dbd109bce4aec52c465930e699f5"
    sha256 cellar: :any_skip_relocation, ventura:        "6c0134dde9b1e7776fc0b1359eb8e17270d1bb34e369728d8e86eff2dfa1b6dd"
    sha256 cellar: :any_skip_relocation, monterey:       "6c0134dde9b1e7776fc0b1359eb8e17270d1bb34e369728d8e86eff2dfa1b6dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c0134dde9b1e7776fc0b1359eb8e17270d1bb34e369728d8e86eff2dfa1b6dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251d334ff49dbd95a838dab0157816b2fdabf0fa5223fb96289f5c6f5e6b57a1"
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
