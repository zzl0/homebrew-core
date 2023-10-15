class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.160",
      revision: "19cc77ade8c244f08850319a1a6467800ea8e711"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1515da098e8591ebc3a63e7fce133e7e33f74d3d9403b5d70859c2689a1ffa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1515da098e8591ebc3a63e7fce133e7e33f74d3d9403b5d70859c2689a1ffa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1515da098e8591ebc3a63e7fce133e7e33f74d3d9403b5d70859c2689a1ffa3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6802a684853f25a29b4db0c1b97c6283abd666c3d2fcecd98fd6a45e4409b44"
    sha256 cellar: :any_skip_relocation, ventura:        "d6802a684853f25a29b4db0c1b97c6283abd666c3d2fcecd98fd6a45e4409b44"
    sha256 cellar: :any_skip_relocation, monterey:       "d6802a684853f25a29b4db0c1b97c6283abd666c3d2fcecd98fd6a45e4409b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36df14b4e25f4b152cd1abbbd48c44a24adb6ace6718fa3ff646a755829dfccf"
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
