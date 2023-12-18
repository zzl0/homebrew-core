class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.54.6.tar.gz"
  sha256 "1af67831930d64b2f2aa89e0b826b6013450fd9706ba5603a4b973132c4c6c48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fdc29460a93f98989c0899abd807b609011dc47cb54f02a2fcf38c40a2651b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10f4a14d7ad7d3804de7707e1e245f72364e41543cb19f2059b6a0b0f97a27c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c71bab493552220c01eb65e43bb07818b5885a822a0a46298a9ac9eea4125f89"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a5e413e5324bc9099635cae81e92de78113fdd9e06ec3f7ff1489aa5be01bb5"
    sha256 cellar: :any_skip_relocation, ventura:        "9f4ab1df2a2791ebdb7036684482138bafb0560a97f09545401918f34340072a"
    sha256 cellar: :any_skip_relocation, monterey:       "913753e1747e3903f59ad5966e89a1dddc0fa9f1683320aba311ef930d62e4bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b79c82c16c493da59cdc11c10b1b990d62bade3e41c4036a8d211ac2cc34e45"
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
