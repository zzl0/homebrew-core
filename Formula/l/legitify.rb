class Legitify < Formula
  desc "Tool to detect/remediate misconfig and security risks of GitHub/GitLab assets"
  homepage "https://legitify.dev/"
  url "https://github.com/Legit-Labs/legitify/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "7f3d59141207d97579a4fbf6d787b1c522b840c2b2be79bac3e056829577040c"
  license "Apache-2.0"
  head "https://github.com/Legit-Labs/legitify.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e16999a7890a25ae818d393c780493a70926ed0c724e4df7f64e198fea31234"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8143a1fdba555238178cfc1895b934eac726a8f6ea5bfeda49ad8c511903a9ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e14a0602173855fa23fb82a89723581d8b9728fc88b5e21d7a44a6720128bb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c90d319f2bdb9f6eb9420a44cb1e08875efc346274d45034927c7c3e25c4a19"
    sha256 cellar: :any_skip_relocation, ventura:        "edde2a50998a8738ca68f09c9f3659904fbc9d4f4212fe803aa02f04f48e7862"
    sha256 cellar: :any_skip_relocation, monterey:       "32f56ae06d33a66d8fce7e1f446b82708a7a40078d874713bbb383462d7fdc33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a575ea3115862ba7406d6a3b81eb5d1b0fda133a826991bc71f05f2502553247"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Legit-Labs/legitify/internal/version.Version=#{version}
      -X github.com/Legit-Labs/legitify/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}/legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}/legitify version")
  end
end
