class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.18.10.tar.gz"
  sha256 "527b6b1559bd2067a53627276d49b99a71192268b7b0e8a028ce76bcf70941d9"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46f275b707189736db7d2970b212d31f985f72724bced3abd2ce9048b87fcab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35f17efef6abfe00b1cf75aa9c4982e9c4be517d4e9abf82575afb05192cccd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43d40ae920e9ae8d381d4765cba586ce91e779c4ab134737bbeeb84edd4bd339"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3f258bcd7c18f7c191be2a3ac9b9b1b8aa21e32bec833b95137e66bf456343a"
    sha256 cellar: :any_skip_relocation, ventura:        "e0522ba097ece939d0d879b31bed490c2a3197b60ba783f971c2dc835868b401"
    sha256 cellar: :any_skip_relocation, monterey:       "d2123bee6db7c143e2a11f158646778d1ed43dbc68d6e2c6a564955f9f50243b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db154c41d5bd41e5696f8dd2efd96e64787f088a9eba8e197d03448c83692a6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terrascan"
  end

  test do
    (testpath/"ami.tf").write <<~EOS
      resource "aws_ami" "example" {
        name                = "terraform-example"
        virtualization_type = "hvm"
        root_device_name    = "/dev/xvda"

        ebs_block_device {
          device_name = "/dev/xvda"
          snapshot_id = "snap-xxxxxxxx"
          volume_size = 8
        }
      }
    EOS

    expected = <<~EOS
      \tViolated Policies   :\t0
      \tLow                 :\t0
      \tMedium              :\t0
      \tHigh                :\t0
    EOS

    output = shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")
    assert_match expected, output
    assert_match(/Policies Validated\s+:\s+\d+/, output)
  end
end
