class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.40.2",
      revision: "9f20f698cdb6bcdce7c9f5995bc382658eaf923c"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6306f3c075e815900601a445f3f7abf2442796b37ac413cbeb2728b1a9875dec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e222a15cd8c207e4a86c00c11ae52839d469c9bc4263196e46a890865d486b37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd0ece6bdbac1c673a0a76cbe18d64cc6590b9c25a42e47ed528ff81515c670b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dd6c897ed71aa81cc3c4a60b57c667707178f8fe083d0481da7bd3ad276855f"
    sha256 cellar: :any_skip_relocation, ventura:        "d6631beca0be1dcee098840b185afd0d84003fbcfb07284037df8f1aea2e1595"
    sha256 cellar: :any_skip_relocation, monterey:       "7a0c3e1df3ea5fc7c801758d1450b4217463e1c5f8b67be6e01a3b3a7fcbd7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb65b49dc68b391c44a1878e26d7416b57f4685f45337c8ca6b720b3ace1dcc7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
