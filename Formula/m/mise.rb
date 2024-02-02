class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/mise"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.2.3.tar.gz"
  sha256 "b23a4e99b39eb1c45c14feb76ad344d90576c42df28274b4e37163dceb33a8ba"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a07249ef6570758466e8fe72d200d81e8bb3196b662dd36b86d1faa04bc46ae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02b3856d55f9684e8864fa9e8da313d05cfa20b1b0f550a6540ef2229e3ee423"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8122d377893fe63e4994f82aa71e652ec89c51e84157240c62c95645c12cf3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cbde8da93d2f4760593c1b296c1000796c02083e5fd698c0a517a89ff4984a4"
    sha256 cellar: :any_skip_relocation, ventura:        "1436373713280544216408623fee68ff42003959f57be188d5c5f6e7542f0b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "de50d6e54a0fc98f8aed25ee5e7795e500c3939dcedd403ee8f8ab0a37b3462e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf236a31fe23f566223922c9b87e11c9596b63a53b52ef2a052d1b97387af7d"
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
