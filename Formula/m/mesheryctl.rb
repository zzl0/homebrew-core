class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.8",
      revision: "1e14a6f08a612edf9d9ee70727793824d562591b"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e7be6405aff9782ceddabb4b323050f23017b30bdb548fa2a48d217eac5cb5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e7be6405aff9782ceddabb4b323050f23017b30bdb548fa2a48d217eac5cb5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e7be6405aff9782ceddabb4b323050f23017b30bdb548fa2a48d217eac5cb5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d160bd854cdd2466d9367aff4af99d88b2f092865a86ca76dfcc24191bd1881"
    sha256 cellar: :any_skip_relocation, ventura:        "8d160bd854cdd2466d9367aff4af99d88b2f092865a86ca76dfcc24191bd1881"
    sha256 cellar: :any_skip_relocation, monterey:       "8d160bd854cdd2466d9367aff4af99d88b2f092865a86ca76dfcc24191bd1881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dd4da245c34da42be013951ac45a3e1f3692c6386dc56a6883ba26cc1f0ab66"
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
