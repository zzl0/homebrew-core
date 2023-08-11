class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.49.1.tar.gz"
  sha256 "e654a04d0aa1efab935da8a92848ced17123c250bf2902b16a38c16e2053389e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c3a50a414eb2d8e000808773035c31134be91d1e363a64d93fb39139c6abe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00c3a50a414eb2d8e000808773035c31134be91d1e363a64d93fb39139c6abe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00c3a50a414eb2d8e000808773035c31134be91d1e363a64d93fb39139c6abe2"
    sha256 cellar: :any_skip_relocation, ventura:        "1fec5549630137f56921c713c2998994c3470ec6ee1b60b589775090511290dd"
    sha256 cellar: :any_skip_relocation, monterey:       "1fec5549630137f56921c713c2998994c3470ec6ee1b60b589775090511290dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fec5549630137f56921c713c2998994c3470ec6ee1b60b589775090511290dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f02dff87e7b054d22b0aad40e6a471062d2ea5e6d2601c0c97ee3284eca47d6"
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
