class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.6.1.tar.gz"
  sha256 "af37cd57b3baf7d74242e1ca347e1821bad6e0931a9e24af8cbeeb51207923f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a34f595cb35af1a0072ea7e4de8347db4914800cfd44bd679dd21b676146a797"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cacad0afb7b0563120c63b7ffa050d9052eff8483c97e0a92c786979efeacf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04ad45a58a30f3287d63deff3e1154cba6728fa6eaec62cb3b83d9087ec92bb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0eac4c543b74d89f696ded2fd27343022aa7440e37da41fd871bfa8ab4162d3"
    sha256 cellar: :any_skip_relocation, ventura:        "2d4d9a0a856a9b95e8d9d7ad6b6ed4b0cbc4baf27d1bf43eb83436d18635ff55"
    sha256 cellar: :any_skip_relocation, monterey:       "31026df13b1fb8b680131a6f15ff4331b67c5eb30a3cb0f1ac9f68acf8d5de34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80087ef717bbb81c882459a745afe743195137dd36fa76d0c542990d4d3a61b5"
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
