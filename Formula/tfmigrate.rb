class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.14.tar.gz"
  sha256 "504dcd7bd0b5e20be25f6f95ce86195af0e79ff0dc3568a9e7ec73f60f83b947"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b5b85cf8c9256c16cdecf10177b19b7e4de8900254ade52f8574c2d9b7fbe70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b5b85cf8c9256c16cdecf10177b19b7e4de8900254ade52f8574c2d9b7fbe70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b5b85cf8c9256c16cdecf10177b19b7e4de8900254ade52f8574c2d9b7fbe70"
    sha256 cellar: :any_skip_relocation, ventura:        "903e413ac46f5eb6657d13fa5d32c5f35ff054a19216547e49de15571c068602"
    sha256 cellar: :any_skip_relocation, monterey:       "903e413ac46f5eb6657d13fa5d32c5f35ff054a19216547e49de15571c068602"
    sha256 cellar: :any_skip_relocation, big_sur:        "903e413ac46f5eb6657d13fa5d32c5f35ff054a19216547e49de15571c068602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "172e54a223e584cee4b2f5f1f1011cf496b4e130af118ada4376fa3a56402714"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"tfmigrate.hcl").write <<~EOS
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    EOS
    output = shell_output(bin/"tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output(bin/"tfmigrate --version")
  end
end
