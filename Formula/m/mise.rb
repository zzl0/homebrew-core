class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/mise"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.1.12.tar.gz"
  sha256 "19e0df02706b1f00118d3405e621643155dc702e84645634a87ddcb964b33a1a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e19716bff0124110ce0302abb2c481e9de04cf0497e880fd83bb28eb252d1ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df1be30cf6f08097b16e8cbb7817733683133e09f6ea267d64ed92fdf060514e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bea2b1049eb6b10070b55ccebbdff4f39b45f65ec0c4782e147d48546555b534"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb2de47fc48286e3e40cfef73d1a34b36394ec0def52e5ff70961e0c930e4fd9"
    sha256 cellar: :any_skip_relocation, ventura:        "909da6305a8be7e36fb207d193e3b053a3cce50fec0f8402a732d270c1d74516"
    sha256 cellar: :any_skip_relocation, monterey:       "bd7a4e564a33386f23adf78601be03e5d40c58c3b04af3b80ada8062150d6f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5403908c993de78380b765f1054d9103e416cb2a9ee3484197a4e795154d719"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~EOS
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}/mise", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/mise exec nodejs@18.13.0 -- node -v")
  end
end
