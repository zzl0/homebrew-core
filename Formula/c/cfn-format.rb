class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "2cdf174a26bf5c73c267e09e8b81d6a2142d8d3ac265b1b002868fda1beea0b6"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "199b082925749b61a5413fa661f0dfb53f7d7ba215a0cb82a1cad726dc1fb75e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65eca0c9d2e20fc86b87651ef00c36a427444b5a4a97487703663bc12d7db851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d331e53a634a3e21e0044953ab390a3961ed30a507675183032c83cbafb0a0ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee24870846d10a2c76d8c50566b1c321c577618439117d24dd1120b3bb4af87e"
    sha256 cellar: :any_skip_relocation, ventura:        "f7c9ae34430b476a9ed28453af02fc187026f402ccb42daed9b67fd8c4cfe324"
    sha256 cellar: :any_skip_relocation, monterey:       "3e504de6e073f26e3a86ecce786ed0e8f085674bfb40f5ba7dade2f47bd14091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d21afef1ca6a3ea780fac9b3e2fbfc8af0b84fdc261c12a3cd34d31afa794ef5"
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
