class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.2.5.tar.gz"
  sha256 "54abf6e4ce69aa761449da2185be968fc7dd537dd050746899b6abff98c60209"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd5c274176dfadef0bc901aecd78b8f226ff0ba80a8102114cb8785aaaa37f78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abc493cca804c2f255d794b57d50ded6f971818a91e0a673454714fbff4f9b7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea93e63946f1e59939f34eeb755a6f64ebc8165edb18fd098ebfe39e5dd7cabb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b7d2e59eab1077f6d15fa3d284faaa8c02d30cca56a43510d221bd7ee75fdce"
    sha256 cellar: :any_skip_relocation, ventura:        "0df14a3c5ca2bc213a84536dbf4528d2657a00790f7224f6b99d3f13fe41c49a"
    sha256 cellar: :any_skip_relocation, monterey:       "2edf49059a088c951982ed791a5398917660b45523f07d327d64c68bdc873321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a94f6e47cee2141c37af18a61d7b908e17ef79163da05103fb627fecc2e388"
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
