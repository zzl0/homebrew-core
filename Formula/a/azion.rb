class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.9.2.tar.gz"
  sha256 "8a4ab32e1a598e76c51625cb8bc3436ee2f1b736454e150209214c78a3fdb1ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9c50a425d4ca0126ba0f307bbcc71f602755fec129c764545df327b17cdd8f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cd9021233b52305a2f6755efdaed3131699671d1a48bff3072a8b2c0437c820"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f2fa239f4f0a3471107583e0edbb2ac04e7f01d9019b3521393843f7ef97aa5"
    sha256 cellar: :any_skip_relocation, sonoma:         "eca7e3c3b82f306d194d599722ffe27c15022ed4e6257fee10db07b41d315e64"
    sha256 cellar: :any_skip_relocation, ventura:        "26278f6676a0a635d25a7e8ae855ae805012bea0592ae86debed37b934bf6190"
    sha256 cellar: :any_skip_relocation, monterey:       "5777c676c16679e255dff8e868fd98ed9013fa82e4fb0ab6d6eacaaf54737b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14435623222e06c366875988ceeaa67df376154b508fb4d50f943c78ca4683ea"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api/user/me
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev 2>&1", 1)
  end
end
