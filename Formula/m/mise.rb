class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/mise"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.2.0.tar.gz"
  sha256 "5e54e9159930822a3f0939625a4590ca62b58d52ecf0fb1e391b6faf4c5fb483"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f7ca405463e98ec19effde51de1c4427bf963db9bdf42051ca8c1eb73ad6942"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba626cd4290aaa867b09ea0a36b3f794602df3a12a99f339900244422cb41d69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c93abc5bd1f08b2591bd77baf9173d01d8c6589d600ee300eb4a8ca7b6bccbf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8d176a1a195dd1a7a78cce3f6e15366c8227ce2594cbe1e78e3e3befbd372c2"
    sha256 cellar: :any_skip_relocation, ventura:        "1597ea5887d598ec3917558c71965846f4a3019b0a4b0ddd87d614a4bdd256ad"
    sha256 cellar: :any_skip_relocation, monterey:       "1552b746b262668aa862a6c28bf7b25722964a2a3b825af218092f08d97a0244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f31b073b156c27b0692c00360e1a533559e86070961a3532fea792f70117caf"
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
