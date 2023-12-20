class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.12.31.tar.gz"
  sha256 "d0b226f16fbfab251ada59fa747b6e18571baa0c21a4edafce85eb66beff7b3f"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73d429f92bf1b3b1ffef9c26f7ed0b28f7c49e6c6c2f7b703aef59dc2288cdc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d0c56324941dbb1e4553b2eb7f314ee7b05593f7986b10b4064d7bfc9b0bd1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d3b023cf97d1fa5a8dda48a60163789967fed269d698ff071180ef67644a5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c765710222af74bc75d1003d0fac12e5954b431ea1534c4527f4b526bc45555f"
    sha256 cellar: :any_skip_relocation, ventura:        "df0ef52a91ef035c5fd76397e6fc228b8f24cfae0cc87dc013f7e4343a42f4f6"
    sha256 cellar: :any_skip_relocation, monterey:       "39cb4a38cd788766e556d007b251232e4f06772703f6dff1299c150f276f23fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54e122aa05c73daa5933ca63f8280c8a1b9a09b71bf61c12171cebd73e33156"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"rtx-activate.fish").write <<~EOS
      if [ "$RTX_FISH_AUTO_ACTIVATE" != "0" ]
        #{bin}/rtx activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, rtx will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
