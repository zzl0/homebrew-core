class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.50.7.tar.gz"
  sha256 "785acd3ee15227bd281e6c7e0a1ea847332036f322136e645385b34a46497b18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93d6de53a503a7eb59a9dab0e4bc2b791dd8b8b5f40677d17eaa9460fba00a6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c22f2dd0b6f98c4430432dd202f3a41f1cf1721328f56953b722154b7dc45cf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d3e117a21a4ffd19798e59272aad5e38a87f361b26b7508216bce14f3a1ea30"
    sha256 cellar: :any_skip_relocation, ventura:        "235edf9751dfa8a3279e65ee41fc27eec12b89ab780703b273fd8ac4c3dd896e"
    sha256 cellar: :any_skip_relocation, monterey:       "6343cb0b53a87b68f5514119bacc50b887570be6a7f10842ac0424469a61b73f"
    sha256 cellar: :any_skip_relocation, big_sur:        "97e53b899bdf320610567b9ff06fe2f69f6c9023530233cdfb5bc80b0c4430f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68cd519d64aebad05d1d5f4cdf1a104064d6bc794d6f5dd37e9f2583fb080a7c"
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
