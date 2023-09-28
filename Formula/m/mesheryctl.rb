class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.149",
      revision: "3b3f37a3388bb5e699dcc927bdfe94d183395d17"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d04e25671e00b7a8da4b4e5bd8dbbb6484e5ea48ecbb5cd02aab837c649f55f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d04e25671e00b7a8da4b4e5bd8dbbb6484e5ea48ecbb5cd02aab837c649f55f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d04e25671e00b7a8da4b4e5bd8dbbb6484e5ea48ecbb5cd02aab837c649f55f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d58f1b3bbb1acba9e38a1f1e80a6bd1931f32542a2f1f0ea601fba8c4780d31"
    sha256 cellar: :any_skip_relocation, ventura:        "2d58f1b3bbb1acba9e38a1f1e80a6bd1931f32542a2f1f0ea601fba8c4780d31"
    sha256 cellar: :any_skip_relocation, monterey:       "2d58f1b3bbb1acba9e38a1f1e80a6bd1931f32542a2f1f0ea601fba8c4780d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d51860412b4150dcbc032ecafc723f7e60cbf3f4dfa15e75e3c1c656f63e00"
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
