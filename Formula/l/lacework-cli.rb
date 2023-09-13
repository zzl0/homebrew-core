class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.32.2",
      revision: "be854786d8b6263864f1678611b2794b7a64c92b"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85fa23580e767350b8a72d351da76fb761755a4c3546fffa608b35f3087c6e03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c4250779decdade8a7ffa5203446830c1e49d2a72d06fe398baff12803c5ad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b73f37eefc8c1e6ea4b5af7888570a5d8afba227eb4dd4fd497256a5127243be"
    sha256 cellar: :any_skip_relocation, ventura:        "5f87384172619a01421e482e75fea9149c8e7477852b14abb8e74dd08216fd42"
    sha256 cellar: :any_skip_relocation, monterey:       "63bfd591a99f0198c60c424a177417041786089ed33b3b990c57b8fe2b00d6f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e6465eb6bf1a1a73d24426a7a525ae42cfaadaf005a1b9822599932cd1128a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78defc6422c549d4e0adc4206389620e2d53e4c23ab2a72fe8cb3bb4df1dcc76"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
