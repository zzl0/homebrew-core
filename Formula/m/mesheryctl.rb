class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.7.5",
      revision: "439925c742f1049c10650d5d26fcaa41eb6d1831"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cd61fc49484e9ac1b8e46199dc444abcbbe6395720da54a4ba6fce6ce3e55dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cd61fc49484e9ac1b8e46199dc444abcbbe6395720da54a4ba6fce6ce3e55dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cd61fc49484e9ac1b8e46199dc444abcbbe6395720da54a4ba6fce6ce3e55dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f46d2622a4782d41c2de74f77d3f6a9bbf07bb2314107eeacae28658e123fe2"
    sha256 cellar: :any_skip_relocation, ventura:        "2f46d2622a4782d41c2de74f77d3f6a9bbf07bb2314107eeacae28658e123fe2"
    sha256 cellar: :any_skip_relocation, monterey:       "2f46d2622a4782d41c2de74f77d3f6a9bbf07bb2314107eeacae28658e123fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24b9a276c18ff84ae3dfb45e6db85af0d719bf57f81d0f5e362007373fd11ea6"
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
