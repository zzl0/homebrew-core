class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/mise"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.1.6.tar.gz"
  sha256 "af03b2b7cad13f772b0373ac0f19c8174e9d3145729db4b37ac4116be33398df"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7baabcc333c87af55c0f057bedbb1acd4bfd42e7b84cd72843bbdc20b57b31ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88919c3b778af5e25188e3d3cf22527dd4a0c3ebc67497b054e135cec4d41c4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0dd4a1758da36f3d55ccc68791edffe0b31e9db3536a769c0f5bfecef991776"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4dd37f30474c6f7970e31c3f6949968b2bb7b78c03681c25c1faae174bb7397"
    sha256 cellar: :any_skip_relocation, ventura:        "a28c8c8ded95dd0ebfd3d9cd49ab26051bdd8e1c549e0ad2c3944807dd3f665d"
    sha256 cellar: :any_skip_relocation, monterey:       "265aa22a06ca58a50eec76e52027c9045066b671540e4285649b191b0cf5ce8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd691e4c55df358206b8e82e67dcc40aa9729fc271838afbd3bfc28c603e0d6d"
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
