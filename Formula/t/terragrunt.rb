class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.54.2.tar.gz"
  sha256 "356ce71389c63fc7596b48be53f0bbca89a39bf45a77256af4821e26365c5847"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e695f6b799963bf96640397b1f23edceb182380d730c7f3eb942f76f56d6e41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "868fbd5a1b4c53454b540cc365ea54d26d2c606408373c52360308483d7f306d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49ca5c60d9fb7d477ba0ae3aab332a034204b8e566767d356bd0bcb9c70f8d87"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d0e07f0f2e5583a11e4c8a661848e3505af69bb55edcd6e26f9c952046b9590"
    sha256 cellar: :any_skip_relocation, ventura:        "795b8f270af4811cc8c644687472b51a91a54c771cd5020c391851a165f14030"
    sha256 cellar: :any_skip_relocation, monterey:       "f6d5b66ee40bc44f36dcc922ca93201df11dbfc26f5a64c92eaa6040d49044a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ff83506345936fb504c697432d33e74cef105a1592595c3b392a48a895ae723"
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
