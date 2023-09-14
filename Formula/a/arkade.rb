class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.10.7",
      revision: "fec33ae658a975b59aa645f23d48e74930f43dda"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "232d762a0c2db34954263c4e6b5142114a776931c15f2cc0836b8890b7e8e3db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d27f9e235eefd1a36d0bd2137a57a357a5d8cf281f2b2de8d4e0a0a793b965"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc03a3761e1ed74c39a9e847f9edcdb4654e47df4ea9c9b0dd9ce291cd34fe22"
    sha256 cellar: :any_skip_relocation, ventura:        "66df0db06a1cdd9bcdbb8bcfdb226eff1e0af537986bfdb0fea32651daa704ac"
    sha256 cellar: :any_skip_relocation, monterey:       "eb259b0bae5fc938c5370b7c02f129846a9d9eaf2e167d49a89aa7ac74d46b66"
    sha256 cellar: :any_skip_relocation, big_sur:        "41fb842bc6186efb4ccd4762b540a4284c8fbe610d9886720e9a1573d4133be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1aebff5f0db41a9914cdf4c6918e5d8d2eeb7b32fa044ecc73522e5f27c9f57"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
