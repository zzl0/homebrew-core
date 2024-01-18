class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.31.6",
      revision: "a543f47319c0bdff16200a7ac40336b95ddfc823"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f999a6701bb68ae4035075ed389b325764cacd3d4fc4ae1aac2d448382ba534f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f570d97d26b113817b42fa41a318a3d43add710fc8bddc70c855d6716732d044"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bca8c97e61272828d20bd0ce450f24547b308790658919f3369edb60dcac71eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f4ed0c72b90f527a32eee6bdb733d2de33154896aeac824ad08511f984c9e99"
    sha256 cellar: :any_skip_relocation, ventura:        "9bba9659430a0bb040ab51d0e1610d110c52b923e084a326bb3fa0d0f2516289"
    sha256 cellar: :any_skip_relocation, monterey:       "8abee51e1e9d458b0eb874908583b6d18521de5c5907591c1f2e595212a0a57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85f317e1c6fa3c6407f14d445aab076173a5ce3bcfebd9fc67c0482ae79c1461"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
