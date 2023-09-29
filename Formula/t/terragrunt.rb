class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.51.6.tar.gz"
  sha256 "3074b9c9d7db6378c87273f9f9887a59e708a8397d276b6b39f7499d8fef781f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2815fcea57d127951e9bc985625e9dd614e50814eac5efeb553bbbaac155fa61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2bd6fcc1c19e69e84cbbcf17ee2ff4bbf842a6a3fff940e81a4fcf4c8d7d097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbced4352d19704217ea3258bffc1bf9ea7726f5afd6ed9eff76a65f1b70c51c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cea800d28b9e8640ff75297a2ffec82662858b4420d13e57af5861b5f66709c"
    sha256 cellar: :any_skip_relocation, ventura:        "60618136596e6ebc7fca50b7e53ca41a1972663df4e120b0c802fa06e8460c10"
    sha256 cellar: :any_skip_relocation, monterey:       "4e655e1eff9b9c3f622c8e4e4212db911f5fbdf0aec6ebf998a7300237ffe7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec332ce9f9a83c8d4a8a69a42868abfa947df6ed4bee09e1af04326c02f86eb"
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
