class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.115",
      revision: "f319604141d1646d8c9c256017874cb10fa325b3"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f708ea53cc23c779dc2949785dd5bd5bc2cb0c537c8b7c66b32c550b28720ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f708ea53cc23c779dc2949785dd5bd5bc2cb0c537c8b7c66b32c550b28720ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f708ea53cc23c779dc2949785dd5bd5bc2cb0c537c8b7c66b32c550b28720ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "65411420fe2f67dfd82d81e4195a0cf99d8f7016fa3dfc12ab05d82e4d696dfd"
    sha256 cellar: :any_skip_relocation, ventura:        "65411420fe2f67dfd82d81e4195a0cf99d8f7016fa3dfc12ab05d82e4d696dfd"
    sha256 cellar: :any_skip_relocation, monterey:       "65411420fe2f67dfd82d81e4195a0cf99d8f7016fa3dfc12ab05d82e4d696dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c83c05b83edce45f084a902dd141093e8e1d5e730404fc5744bd9d9fde4a453"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
