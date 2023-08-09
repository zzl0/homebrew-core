class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.48.7.tar.gz"
  sha256 "36831424043818af7c27ca3cfddaa307fa7d5dd956e2677953536cb58e0aaac5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "204f714c84fd11546db91d7a26df360daceebbc5a742124b7bede3e7adaa2300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204f714c84fd11546db91d7a26df360daceebbc5a742124b7bede3e7adaa2300"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "204f714c84fd11546db91d7a26df360daceebbc5a742124b7bede3e7adaa2300"
    sha256 cellar: :any_skip_relocation, ventura:        "2459173dc5f3ed6012651ec2dee5240fd1f3aac59a2d97dd19a046048deb4ab5"
    sha256 cellar: :any_skip_relocation, monterey:       "2459173dc5f3ed6012651ec2dee5240fd1f3aac59a2d97dd19a046048deb4ab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2459173dc5f3ed6012651ec2dee5240fd1f3aac59a2d97dd19a046048deb4ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef577cbe3f8937f36e79e9d4a1f10c010c8bc222d108ad1777b011ce609bc262"
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
