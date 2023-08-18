class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.128",
      revision: "0700d8d68ce069b90a07481400501f2cf5259bcd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ed605c98ef8bfefc9aee312a8d44371a8f9bfe82fec1c69749488f1bc42cfcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed605c98ef8bfefc9aee312a8d44371a8f9bfe82fec1c69749488f1bc42cfcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ed605c98ef8bfefc9aee312a8d44371a8f9bfe82fec1c69749488f1bc42cfcf"
    sha256 cellar: :any_skip_relocation, ventura:        "9ded1e7fd95a7515536c3ad41dc713f9b7cecbfbf5478a4a2acdb41005ccc897"
    sha256 cellar: :any_skip_relocation, monterey:       "9ded1e7fd95a7515536c3ad41dc713f9b7cecbfbf5478a4a2acdb41005ccc897"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ded1e7fd95a7515536c3ad41dc713f9b7cecbfbf5478a4a2acdb41005ccc897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec8a348a1be1cf9b6ea8cee4cc92b106e53e7305fccc0b460fb19c13b7c071b"
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
