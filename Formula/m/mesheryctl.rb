class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.158",
      revision: "f2cf248fdd6002180d7a01121247b499e108aac1"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c42cba1033b0aa33e458eef629ce6369726c498c34fd10b16d8c21750983824"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c42cba1033b0aa33e458eef629ce6369726c498c34fd10b16d8c21750983824"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c42cba1033b0aa33e458eef629ce6369726c498c34fd10b16d8c21750983824"
    sha256 cellar: :any_skip_relocation, sonoma:         "562a5e4c00d8afccaafd789db0e4241ba1bdfcc5a6f5d49bcdef4f5befe310ba"
    sha256 cellar: :any_skip_relocation, ventura:        "562a5e4c00d8afccaafd789db0e4241ba1bdfcc5a6f5d49bcdef4f5befe310ba"
    sha256 cellar: :any_skip_relocation, monterey:       "562a5e4c00d8afccaafd789db0e4241ba1bdfcc5a6f5d49bcdef4f5befe310ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7debcc99f12752b8ee76beff6c9de7fdd6394424b5c4401ffc8f196fdb04ad7e"
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
