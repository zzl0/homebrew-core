class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.122",
      revision: "544e45e14710fa6c8ae5506cc5e528ca24a97818"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9519f116a7806e640a5778c2e2654a6f09c498678fc1e67c8f3ec74e4d512232"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9519f116a7806e640a5778c2e2654a6f09c498678fc1e67c8f3ec74e4d512232"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9519f116a7806e640a5778c2e2654a6f09c498678fc1e67c8f3ec74e4d512232"
    sha256 cellar: :any_skip_relocation, ventura:        "bf0ac33093f0beb45d65c575a8860289ce8e79ff98b0e048749feda2040b73ad"
    sha256 cellar: :any_skip_relocation, monterey:       "bf0ac33093f0beb45d65c575a8860289ce8e79ff98b0e048749feda2040b73ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf0ac33093f0beb45d65c575a8860289ce8e79ff98b0e048749feda2040b73ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b41d211884ffe30e8358cb2fce2328bc9a7e52193ebee641383dc9698641586"
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
