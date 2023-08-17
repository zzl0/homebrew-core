class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.176",
      revision: "2272e828eb9660917c8639a0b93881359f2e7d43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5e1a8759c3fa7d897b66ed2a51021e5fb507807a790a78be5cf9ec902d711eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "562feacc002362b4cfe8f147d0edd2d1191ce320e412b76483681652d5eea9a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbb5a12c4874f4bcafaea0dec3bb0251db5c6110fb081dbfd757bef65d5917fb"
    sha256 cellar: :any_skip_relocation, ventura:        "242a6da787f82367b8042eb8d3a78dc6f0e15578102cc166b6aea4e7c720a930"
    sha256 cellar: :any_skip_relocation, monterey:       "10f3d83ccdc85dd6dc162aedee93422a1e476812753694a36c9423e3ff784976"
    sha256 cellar: :any_skip_relocation, big_sur:        "daf9e40dc1ece88bc1e0449e2bb7cb71b2b900702173a9fc24eda76dbcdf74eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80b3723458846a107bb5640cbe2ba353bd76b0ab6ce545df4695365aaec1147b"
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
