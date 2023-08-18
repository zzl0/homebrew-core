class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "64b585b6c40446a7715c654d512ba3912b6a6669c3e93a5ea7e5cfe9f960b217"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc6c15d742dd629f5c3cfb6fa393837c801dcbfe2b27a0caa43e9c46016c801c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc6c15d742dd629f5c3cfb6fa393837c801dcbfe2b27a0caa43e9c46016c801c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc6c15d742dd629f5c3cfb6fa393837c801dcbfe2b27a0caa43e9c46016c801c"
    sha256 cellar: :any_skip_relocation, ventura:        "79ca4ec9bb3ff57b6a831331a4e286b891372e6e8cc362440e2745d82356ddae"
    sha256 cellar: :any_skip_relocation, monterey:       "79ca4ec9bb3ff57b6a831331a4e286b891372e6e8cc362440e2745d82356ddae"
    sha256 cellar: :any_skip_relocation, big_sur:        "79ca4ec9bb3ff57b6a831331a4e286b891372e6e8cc362440e2745d82356ddae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddd31f530de2e7a704b977cf8bdb7e560bc2947a7658d1c39f9d137e7575f128"
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ldflags = %W[
      -s -w
      -X k8s.io/git-sync/pkg/version.VERSION=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/#{name} --version")
  end
end
