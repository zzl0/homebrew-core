class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.115",
      revision: "7d5842400c40adf57a452acd9f1a0dfe9f77da67"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "033142cf59009ebd02cb0a317a3107e5ab58932d45e28ea5212370cd4c9efc89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "033142cf59009ebd02cb0a317a3107e5ab58932d45e28ea5212370cd4c9efc89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "033142cf59009ebd02cb0a317a3107e5ab58932d45e28ea5212370cd4c9efc89"
    sha256 cellar: :any_skip_relocation, ventura:        "e43de20b16b4be79892361ebe2506c72a0d9a44ef1b68bee1b63b943175b61a2"
    sha256 cellar: :any_skip_relocation, monterey:       "e43de20b16b4be79892361ebe2506c72a0d9a44ef1b68bee1b63b943175b61a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e43de20b16b4be79892361ebe2506c72a0d9a44ef1b68bee1b63b943175b61a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85c48b21e5d4679ca531789cf1de83b71488fd481334fc20ba12e923a3b68566"
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
