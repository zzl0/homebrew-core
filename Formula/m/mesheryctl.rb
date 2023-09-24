class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.146",
      revision: "9ac1a86917573e5cfd201b71ca6edc55e869637c"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df33f61cc621797ebb6c50a08568e26bbee2eb7a74c309a7aa7c9fc44c324bd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df33f61cc621797ebb6c50a08568e26bbee2eb7a74c309a7aa7c9fc44c324bd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df33f61cc621797ebb6c50a08568e26bbee2eb7a74c309a7aa7c9fc44c324bd1"
    sha256 cellar: :any_skip_relocation, ventura:        "330887ef57cfd8905df15dffa1e8c168f1f93fe86a3d678c1a41e06fa295bcce"
    sha256 cellar: :any_skip_relocation, monterey:       "330887ef57cfd8905df15dffa1e8c168f1f93fe86a3d678c1a41e06fa295bcce"
    sha256 cellar: :any_skip_relocation, big_sur:        "330887ef57cfd8905df15dffa1e8c168f1f93fe86a3d678c1a41e06fa295bcce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41da3d8c0ff473bfb534880c106d05c0c04ccffdfc905e04aff240c8f9da293e"
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
