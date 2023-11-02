class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.186",
      revision: "370881246e0bff80f5961cc462c92d8cd8d00379"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bde8bb366c8d301edd509899f8a55734541a0d88d79004c8c08d5c02e364a71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1096f125c41d595ac4b46a6186986b4d8d76e7b07ae132856826bbf6b89e4e52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f2a093e5de5ee1798f0300a2498944b4ae4292c4e12c4c8fe69a45cd55113b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d541d2e377103e275a50cef2df8312fdc18d95d3970e1d8d62a1b71f9b9866b4"
    sha256 cellar: :any_skip_relocation, ventura:        "a51e53eb893b400867ee7d7dea9b825100d83bc2aa9236c49f9b8849d3f90fe5"
    sha256 cellar: :any_skip_relocation, monterey:       "396c87c1547a9a018771956a2402b05495b14f76ea1187e483b27ed900f88d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "946fde360293f140a5265f72c2d15cf0e554a9b2771d5a0a397853e7e9fae652"
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
