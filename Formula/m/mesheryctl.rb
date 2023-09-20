class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.143",
      revision: "70c66f209c2639fd9d8c587fdd4279019e0955df"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c24901715efefa9b09a35659c781dbeac2f0352bdb9902593f89e40906f97eed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c24901715efefa9b09a35659c781dbeac2f0352bdb9902593f89e40906f97eed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c24901715efefa9b09a35659c781dbeac2f0352bdb9902593f89e40906f97eed"
    sha256 cellar: :any_skip_relocation, ventura:        "16ccd25825c572f98051b6b13d98dcc32f8d8a96e1c1e37b9e04c0a90f2fdbbc"
    sha256 cellar: :any_skip_relocation, monterey:       "16ccd25825c572f98051b6b13d98dcc32f8d8a96e1c1e37b9e04c0a90f2fdbbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "16ccd25825c572f98051b6b13d98dcc32f8d8a96e1c1e37b9e04c0a90f2fdbbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cb3d887251f894d526e4d842857c7dbb18f62b260c1010819f40605b8111c83"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
