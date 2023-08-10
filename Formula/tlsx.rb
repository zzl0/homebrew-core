class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "8a75d2d77c8e7fe20c744a86dd7d1b7905a73028f46692363957928658f39df3"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34362af7f11c94f3944d991a9d0f40569f4ae23923bf0da5557c51c8ffa99b4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34362af7f11c94f3944d991a9d0f40569f4ae23923bf0da5557c51c8ffa99b4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34362af7f11c94f3944d991a9d0f40569f4ae23923bf0da5557c51c8ffa99b4e"
    sha256 cellar: :any_skip_relocation, ventura:        "6ffa9bc80a1a0aadfc2d61306574fb9005dac8fc2e57ff82ef58182222b0dc18"
    sha256 cellar: :any_skip_relocation, monterey:       "fe784fbdd3fd6f776a3201fa9322637102b37e692ec71176405bca9ac8c12fb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c62ad0ca53b47e92218f51688571d738d1b8e0d7ca868e8d414d54917c363cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1868163228ea482e99f41db13de3967f04a1d129236b6bab19005c8dd8676320"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tlsx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlsx -version 2>&1")
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
