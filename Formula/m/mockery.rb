class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "b8ef86291f86db1b6d01001b2485af3833348919fb51d61b661f29ad0cd93aad"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2a2b7bb60e0b6118de346336b574f9dc2a2476bc209586a5f7cb5da909a7d68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2452d955ea3d3bee76de1eaa0b6a52f8034d0a3872197c374eed6af8f754af2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db6a8e1c07716b52ca2c5ffa6e66078e5fb3ec383c0bf943a0e27a6a60e838c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "602aa54d35b05a33716abaf76529bcae2519b40ce19cdc01536d6b9c93ba4f8f"
    sha256 cellar: :any_skip_relocation, ventura:        "32db87db2b974020736024877077d908b6c8d63926d1fec9b953255fed27e6df"
    sha256 cellar: :any_skip_relocation, monterey:       "5b4cde2eea87403db60505f10a85c655ecac2de54c613e99da370e370b62d377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "237b704660cb4e081875e1fcf4683ebff2633d42dd45db553b467d97debf0d43"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
