class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "cd0b3dfe1992d1a680cadc363fcbcbda7f67dd7b4789178a4425e5cf0c4ba961"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0e8e4503ac67e7388b981d7f082ce267d7dfffce39fbc60ba995493e6b9d6f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0e8e4503ac67e7388b981d7f082ce267d7dfffce39fbc60ba995493e6b9d6f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0e8e4503ac67e7388b981d7f082ce267d7dfffce39fbc60ba995493e6b9d6f4"
    sha256 cellar: :any_skip_relocation, ventura:        "0483f464821cc874b882d6662cd10b300c117dd6d9e755e264c5788fee5f7504"
    sha256 cellar: :any_skip_relocation, monterey:       "0483f464821cc874b882d6662cd10b300c117dd6d9e755e264c5788fee5f7504"
    sha256 cellar: :any_skip_relocation, big_sur:        "0483f464821cc874b882d6662cd10b300c117dd6d9e755e264c5788fee5f7504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb6abc9bfa1b6661c1490e7aa495574bf01093f44f9990f5c20ec778d75aad72"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
