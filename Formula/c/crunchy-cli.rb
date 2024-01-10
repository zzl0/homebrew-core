class CrunchyCli < Formula
  desc "Command-line downloader for Crunchyroll"
  homepage "https://github.com/crunchy-labs/crunchy-cli"
  url "https://github.com/crunchy-labs/crunchy-cli/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "a274844f46f525b048b7f06eeb823a4377b1609f48d589dab321575f3b617697"
  license "MIT"
  head "https://github.com/crunchy-labs/crunchy-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8782dc293a91e3adb71a896df245e4a6fc5692c1ecf0a31cc00219261c54817"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e3781ef7dbf96c3475853ef572ba909d50bc599bb61d52dcbfc61e01ebfe353"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "586cd5dbdfb17d3a1931c897f96c1e4cf30e1aa1c87c5ba13abf89e1c0f126f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f291b506fa39115399fffe142de2724d8c6bb0e008b3c1194b597bde285653a1"
    sha256 cellar: :any_skip_relocation, ventura:        "98c6555fefffa582be1dfa605aef1806133913a975e07f2eba82ae37cb801913"
    sha256 cellar: :any_skip_relocation, monterey:       "6224638785a923a9c48631268aa57b98eaeed5514d5e8dcee0bf0c2474dd2f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bafe61e08f1360327391e7b7cb263e47879450352bf3fdbc04464ad17d094676"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--no-default-features", "--features", "openssl-tls", *std_cargo_args
    man1.install Dir["target/release/manpages/*"]
    bash_completion.install "target/release/completions/crunchy-cli.bash"
    fish_completion.install "target/release/completions/crunchy-cli.fish"
    zsh_completion.install "target/release/completions/_crunchy-cli"
  end

  test do
    agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/119.0"
    opts = "--anonymous --user-agent '#{agent}'"
    output = shell_output("#{bin}/crunchy-cli #{opts} login 2>&1", 1).strip
    assert_match(/(An error occurred: Anonymous login cannot be saved|Triggered Cloudflare bot protection)/, output)
  end
end
