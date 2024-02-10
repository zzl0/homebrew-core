class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.2.10.tar.gz"
  sha256 "7cc60f9ec818bf5224bf242d1a22ab84de549cb66c3accdd2050f5d5675ea698"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "109790346b87852c1fc92cf69b53a379c8af615c955e5272a9839a38f77f623c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91d5c569cc60267ba283b6d1328892304d212cd23f28ae385a9477b47ef6123c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce25420050d222b20ab6a177eb1fb5de86091bb807efceebbababa6d0d834f28"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a48a4579c09b2fc1091b9ae25330431203c11b0658c18bb85d15d400d44eec5"
    sha256 cellar: :any_skip_relocation, ventura:        "30ca2d57791dc0a74d62ab3b7f93ed2e7721c797f323023dadb71f6dc47a831e"
    sha256 cellar: :any_skip_relocation, monterey:       "cb3651509d33922ccaef7cee14fa3be0aceebecb04ae69356ed870a6d6fc51fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ece674b27c70c9b9b7760b3ba996b3e766ec66ea47e10562c9615f26e162363"
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
