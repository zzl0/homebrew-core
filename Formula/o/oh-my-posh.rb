class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.7.0.tar.gz"
  sha256 "244a9ac774f92350101c981824c4025d12ebaaccccd3c673eaccb7b2df6f3471"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cfb6185aeec09377014dce9ce12f87950381e71c45ad23a3506fa5a35880605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc40952e329d5bbd37969462d9ab94f6850357979dbd2f8cc46e8fe0ac34bf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c84661f568b37d8419f54ada87622f8befebf6070a61465d82d6f0718abbf36"
    sha256 cellar: :any_skip_relocation, ventura:        "4da64b9ea9e6da52b4ad5c60b26cc420f5150dcbb9858555217d5c2c2acae0ff"
    sha256 cellar: :any_skip_relocation, monterey:       "44a4d20b572ed7c231f67d1c643b602c25db6997e227f789cd6ebb7849262e26"
    sha256 cellar: :any_skip_relocation, big_sur:        "2867a09cc2ec175ea2031842e09ff3a5c6eef31c2dfef130b064c403cf87e714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c50bb07ae91743303fa09b15490b589011adac17b503ce6a7d1c30487de375b0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
