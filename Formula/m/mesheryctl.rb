class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.169",
      revision: "87e757b03cfd9a76ad7b021062cbcc36fe8238a8"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0932b81ce3711055764106b67c5c23e1814a8eead3aee9d206a5852fb29618e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0932b81ce3711055764106b67c5c23e1814a8eead3aee9d206a5852fb29618e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0932b81ce3711055764106b67c5c23e1814a8eead3aee9d206a5852fb29618e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d1bfc0bcd5377ba6a2a9857a2de0d4cf3c28240459c9c079ff56bddbc676aeb"
    sha256 cellar: :any_skip_relocation, ventura:        "8d1bfc0bcd5377ba6a2a9857a2de0d4cf3c28240459c9c079ff56bddbc676aeb"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1bfc0bcd5377ba6a2a9857a2de0d4cf3c28240459c9c079ff56bddbc676aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cb3935a8793418dd8252a770927a7733fbf054e35e3efa1e1a6467971be53a3"
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
