class Pop < Formula
  desc "Send emails from your terminal"
  homepage "https://github.com/charmbracelet/pop"
  url "https://github.com/charmbracelet/pop/archive/v0.2.0.tar.gz"
  sha256 "360db66ff46cf6331b2851f53477b7bf3a49303b0b46aaacff3d6c1027bf3f40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bca42bc3e76cf9252753557f2c422a27548f83b1f63f1f200be7e769c0a77591"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bca42bc3e76cf9252753557f2c422a27548f83b1f63f1f200be7e769c0a77591"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bca42bc3e76cf9252753557f2c422a27548f83b1f63f1f200be7e769c0a77591"
    sha256 cellar: :any_skip_relocation, ventura:        "e17ee0449fb0463193f8ac28bf000977e16aff41c2f4e55e804659302c7c9d68"
    sha256 cellar: :any_skip_relocation, monterey:       "e17ee0449fb0463193f8ac28bf000977e16aff41c2f4e55e804659302c7c9d68"
    sha256 cellar: :any_skip_relocation, big_sur:        "e17ee0449fb0463193f8ac28bf000977e16aff41c2f4e55e804659302c7c9d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b7a91d27becd83aad04f8ccbf56945d52358c29546a481fac725c249d039a8"
  end

  depends_on "go" => :build

  # patch error status code, remove in next release
  patch do
    url "https://github.com/charmbracelet/pop/commit/65b34a366addd90a9d4da32ac8e5d22268ec16bd.patch?full_index=1"
    sha256 "386fda7d26240d5574b7f402595d01497d7c2d3254e6ad9276a8dd02de0513b7"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"pop", "completion")
    (man1/"pop.1").write Utils.safe_popen_read(bin/"pop", "man")
  end

  test do
    assert_match "environment variable is required",
      shell_output("#{bin}/pop --body 'hi' --subject 'Hello'", 1).chomp

    assert_match version.to_s, shell_output("#{bin}/pop --version")
  end
end
