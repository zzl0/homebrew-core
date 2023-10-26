class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.52.6.tar.gz"
  sha256 "d67b567f52bae3a2eef426876d08db339c2fb9a355b25e1ccd2219ff2c3c9e30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f790b3751752884ca4055c1f06f39b6e71073843c88b33053e8ffe3fc204a99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fdf15b8811c744b18c793c984b56d42da9132be6d33261f17e78c0d4c771ec3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a34df93e0f0154f10ac1d2b3e94dd19084ecbd2dc9524951cd68a24a568eaefb"
    sha256 cellar: :any_skip_relocation, sonoma:         "9694a59a9aa482d371b295e07bf30fef9128ee322ad17039c36058ba5a878cbb"
    sha256 cellar: :any_skip_relocation, ventura:        "eee90d54fda1a41afe9f7c91a32bac1732cc8cec4ea9ca930d9b9829d2755022"
    sha256 cellar: :any_skip_relocation, monterey:       "d78ae3785b903012f634bb89b846dc96ac8adbd3bd26a955d21f95ed6ec4efaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07b7f39005c98d1935c01cb60ed61d82c1f3e63f335fb1e7909d7918995b2cab"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
