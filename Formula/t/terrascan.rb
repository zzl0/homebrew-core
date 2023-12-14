class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.18.7.tar.gz"
  sha256 "77bf10138ca908441b942197b965dee7417fb6d3cfe0673b2c702b8c4167be4b"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2081394f6411ac17582e07c68ed6a09c1b14950170f45703c3dd7237e51c8ad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6439a8fefc6cd6ded85f07db0c71e2ed7b202b9e86f0e6506c7a01fab3de5dbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f6aa7f231acc38b0e9d7c5767fde9eea12cff748064cbb4770692680991cbe5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5270f2d296153be317da572d564277c40e0bf67e7ceaad7adf30ba9b99747f7"
    sha256 cellar: :any_skip_relocation, ventura:        "9cfabcbc84e8ec6fca25315bc45c7ea65b2da802657b3987832e6ab6ab83c0dc"
    sha256 cellar: :any_skip_relocation, monterey:       "60b38f85ffa59e33d2a35cc38f5a0ddfa90f390d7af66de0169f90c8fa3145cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1067dab3055fd81b7260648707e8ed7b59f79f29bf925d87c06cb6ba1a6cd6e"
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
