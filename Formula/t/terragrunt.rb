class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.54.17.tar.gz"
  sha256 "02d98e941ed36c0a4e8fbbe7131dd4bc84897d304880fdc7aa94a17ae411794b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "082840c921aa6d5a99dc215ff4998100e4a84aab35c2b58fdc3c0bd00f4d5a0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a50550bd275d7faadf0cf3f301aec5fb695b9fc28f5f2bb6a64675d3765b927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed18711c57757b1bab50ac54c2e44c4db89e6a04bbedb6720754a89c2b8d2113"
    sha256 cellar: :any_skip_relocation, sonoma:         "d62014d44aa79e795e0da2f3100e666ad09b87b4524814388b461dd84fe7d5a9"
    sha256 cellar: :any_skip_relocation, ventura:        "684bd2c2ba9ab676ec04475dfd2f9f4d49f69e7bc91f1a61bbd7210d3196a8d4"
    sha256 cellar: :any_skip_relocation, monterey:       "1ef3786bb24c115a153c372c37818a775681d4ec28a38857318192dece622dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bce4b0f72b936ed026cbf7d24dc892b7c20b1775b4b86ef9c601463cbed9f92"
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
