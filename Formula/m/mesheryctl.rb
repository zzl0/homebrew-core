class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.2",
      revision: "c966c2a0bb45966fc2e7ad229171232c537cd63e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c58982878356e5b306be4e2ac20b39e0ef92d375db651827e12cf73dac8a664"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c58982878356e5b306be4e2ac20b39e0ef92d375db651827e12cf73dac8a664"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c58982878356e5b306be4e2ac20b39e0ef92d375db651827e12cf73dac8a664"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a6a4e19060e8d8cf40a8999a54466a5611c9ccef3857d3c7e0a83d2d70b5628"
    sha256 cellar: :any_skip_relocation, ventura:        "8a6a4e19060e8d8cf40a8999a54466a5611c9ccef3857d3c7e0a83d2d70b5628"
    sha256 cellar: :any_skip_relocation, monterey:       "8a6a4e19060e8d8cf40a8999a54466a5611c9ccef3857d3c7e0a83d2d70b5628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7e5d010b0c377d483edab1db3fbd4c13ab07889a64b485ab98684a8e2700882"
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
