class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.183",
      revision: "5eceb46dfdddddceaed5822e1464da302381ddce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97576a94a44492412b836b8e2bc55d19c60edb28bc79590c4ebb0190f9a4f8f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8b0776cb37566e287e681cbf03798c92cc3a7993590502706a836d6767f3b7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11280096332a6891bc0480866abd595652fb9e4c584403ecbfacc1d19ba15509"
    sha256 cellar: :any_skip_relocation, sonoma:         "14b55e875cff0ff0b1478c977b8dad1f8bb8b49ac1467a2d97a8a6f726264acc"
    sha256 cellar: :any_skip_relocation, ventura:        "1882d3d4785f7f179a60160a9d33b34b593294874aea44c09827307de9bfe93e"
    sha256 cellar: :any_skip_relocation, monterey:       "e55608b934f1230db2860a0d7b06aaa77aaa8cd0339a4f1b570b7a00664ab70c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab5aee0513e97c6861a8f385107360bcad7c6efaefe5e090a461b410f86b5c84"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
