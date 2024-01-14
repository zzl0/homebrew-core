class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/mise"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.1.20.tar.gz"
  sha256 "29ca573a77f256c220817eebbf16fe61af944620b869dbce8472880e64bcbe16"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "970e8d0be95183ede72fb9970212e0d3812a84a13f8cb984951e7bb7ca173702"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c4d2ee527c7ecee54b03592d05fdc59e9d3605fc392b12ad7f2a7d0e4430f64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aa0263401871484cfb770055fefa48da85a829328460106bf144867b04a6831"
    sha256 cellar: :any_skip_relocation, sonoma:         "70e62b1a6f8be6a5274a6084008f6d2597f407a9232cbfd1a8311fe48c6ae7e9"
    sha256 cellar: :any_skip_relocation, ventura:        "b0564506a2f6731331b5e7209c7e08b8eccb56dfb7ff8f15dac132dc67f35790"
    sha256 cellar: :any_skip_relocation, monterey:       "0655a70db211df296bcfc4bcef7687b5d254c8004bec9a03dc796f9ac718d1ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bdba8bd113fb465f65c061d343764ef9a106128801584571910a0cb96c5f8c5"
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
