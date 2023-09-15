class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "1e6acc3a8227ebf5b830936db22b3f5b947ccdc32655bbd90ad1f966f8565ca9"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f6434ab0123b6fa83b79cb8e7edd3b3b206b0db422f8addd5cb387b966a2417"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6ba949fff31ae1b1ab66e2383cdd424ac7389a0a492c788a099bab5da01becb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d8a51f394e7485e33548a2713dc063d0f02eaf5a94d8d86b8744112812b9df4"
    sha256 cellar: :any_skip_relocation, ventura:        "1ece1d628936ad4987aa1b032ab32bcab8ab9be695162077c6b8cef1ef4554c9"
    sha256 cellar: :any_skip_relocation, monterey:       "342cffcdf10be7095e59e73fd31ac19cd8bed200caeef75a6f0dd3c60458f33b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cb3d2726d029cd50955b7f7654f7a0f0250904c085123bc94c2825b66776b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "083e6eabd12a02b3d962441df7f7795d6d57c095d56035e376fa02dbcf196777"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end
