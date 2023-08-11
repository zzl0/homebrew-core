class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.4.tar.gz"
  sha256 "e9cb12dce01fd38c2a642fb5850db7ccc3c77d22e135449430279ac061c7a61e"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa715486304a5d0bfba960bcb4398aad05de0f10260a32ab58960aa0c0426244"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa715486304a5d0bfba960bcb4398aad05de0f10260a32ab58960aa0c0426244"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa715486304a5d0bfba960bcb4398aad05de0f10260a32ab58960aa0c0426244"
    sha256 cellar: :any_skip_relocation, ventura:        "2eceae300ee27e0bcb0e39594ceabd02f0c5da2e51d3d2ae8607c998d0a8f570"
    sha256 cellar: :any_skip_relocation, monterey:       "2eceae300ee27e0bcb0e39594ceabd02f0c5da2e51d3d2ae8607c998d0a8f570"
    sha256 cellar: :any_skip_relocation, big_sur:        "2eceae300ee27e0bcb0e39594ceabd02f0c5da2e51d3d2ae8607c998d0a8f570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a708f83789bb39f0afb9e8b3c2ae944d88def7e9ae13c02b5b6254ae2e41d43"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
