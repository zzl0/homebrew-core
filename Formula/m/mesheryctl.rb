class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.160",
      revision: "19cc77ade8c244f08850319a1a6467800ea8e711"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e2d1e6f342596753c0063f946a45b29373f895ec10c8413298c542a0b3a2822"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e2d1e6f342596753c0063f946a45b29373f895ec10c8413298c542a0b3a2822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e2d1e6f342596753c0063f946a45b29373f895ec10c8413298c542a0b3a2822"
    sha256 cellar: :any_skip_relocation, sonoma:         "519184ed9a67a81a2d6fb4af9cf251667139478b85aa4045350a930d3dc6bada"
    sha256 cellar: :any_skip_relocation, ventura:        "519184ed9a67a81a2d6fb4af9cf251667139478b85aa4045350a930d3dc6bada"
    sha256 cellar: :any_skip_relocation, monterey:       "519184ed9a67a81a2d6fb4af9cf251667139478b85aa4045350a930d3dc6bada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d17078ae2e22a7ea3a65ef601e38f7c9f6b98c1a3046e2472eb0a8efb9f792f9"
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
