class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.13.4.tar.gz"
  sha256 "22f9533b117ee8f084404e59354c4f19c75846f8ca53b2c23fd6a55d2f2dcb09"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9933ef801852972588f3fec7784a05191c68e46d4291ddfc768e1ef37bdffdba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "445fb79804f6c7c12dfbab07625fedf92eef80bd6d5fa86ca79b8497f01850d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d5e5fcba73696b172633d66d43a817d16c491a1c4bf8243428c38455a7a5cd5"
    sha256 cellar: :any_skip_relocation, ventura:        "c6182c17d1847300384a3649b9290b774adb0af6b27669c78ed468ed76b379af"
    sha256 cellar: :any_skip_relocation, monterey:       "e69f972dc936376911bab6f2ae89711cb3a60f406e343ecd2baf71d6feba1f72"
    sha256 cellar: :any_skip_relocation, big_sur:        "422b7bb7efaa73238cee9d3d2200c7a2cdb6e293245466839bdb1bfac4207958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4d8a479a49d59ee860eff0716ae8aa788436c607e6d127d389c38b5b7dff221"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
