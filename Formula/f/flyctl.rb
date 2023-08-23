class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.83",
      revision: "64d1ddb772751c502a038458af4f93fcc9d6a199"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19255a0edd71f0dbfe21a20c63abf0193ab47b12d7d588e6cf404f3385ca0edd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19255a0edd71f0dbfe21a20c63abf0193ab47b12d7d588e6cf404f3385ca0edd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19255a0edd71f0dbfe21a20c63abf0193ab47b12d7d588e6cf404f3385ca0edd"
    sha256 cellar: :any_skip_relocation, ventura:        "a9fb8af70d5bd7893248bfe8e22ec2884ef359039310229d3d60affea6f08a3c"
    sha256 cellar: :any_skip_relocation, monterey:       "a9fb8af70d5bd7893248bfe8e22ec2884ef359039310229d3d60affea6f08a3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9fb8af70d5bd7893248bfe8e22ec2884ef359039310229d3d60affea6f08a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "858c147ccfc4dc147d03bc0e0e6d048fdb5c246bfd970b871138a6a7080e4784"
  end

  # go 1.21.0 support bug report, https://github.com/superfly/flyctl/issues/2688
  depends_on "go@1.20" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
