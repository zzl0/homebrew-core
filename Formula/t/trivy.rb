class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "228a9970abf610a740c469eb6c7384ab610d1644d53be00514c81da608e04d5b"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd2b756ae713669559b5fd76cbe43d9b5c65bd8acac39c445346c08fd77ad436"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b2ef30ac9efdde8c5fb5b3e394f851e95070938e275a96a86bf014f0f3ba43c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77f917a6c9198d0e718d6a8d90c9327aeb0dedad696408f256f521c7134a6ca8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fbfbf522c5a0fd1dd31b2499bef6b3e57bfe50c62f0b4edc122613a5eb979a5"
    sha256 cellar: :any_skip_relocation, ventura:        "cf62334b466886cabdc10f7952aec7b76d78e4cd9119c9ad536f0b4955a6d142"
    sha256 cellar: :any_skip_relocation, monterey:       "a00152cb994b7fed7786aee4a36807c19669658f81a26db875f0e009c925a78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8de58bcd021a10d2c55f2f68d1ca1b51d2329c8a65eb5434d0ba632f2aa5ab2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
