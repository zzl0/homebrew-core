class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.12.32.tar.gz"
  sha256 "e1f7cb03195591f7fdfd7ff53a831d57799b6ecd857d673b3ed2537b35fd80f2"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27fe01bbe7c9cdd4125ff61cf82bf04d6f94b6de7b0ef587edf2e31a5c105af5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6312aa88a185275da5c8cf14ab32684a567694b8da9eb39ccfa687ae40a7c50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "151922da3f2ab1261fb5d23ab6f85fd480095ceea880cbe3ec3377f1d7d69aa7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bc0f872bdf7cbbe2271822bbcffbe05b4d4bb0b2759a37008082a54a2bcfd04"
    sha256 cellar: :any_skip_relocation, ventura:        "e5fd44760f1326554a933a85efa34ee2bdd34a1ec068d3952dec2e161a6f3827"
    sha256 cellar: :any_skip_relocation, monterey:       "99bb2a2773c4a706cab1b1c14bab128f252b19cc92ce378b684e5e08bc1e9079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a1188b51db53acefee232ea7604e651ef9fe174d2f9698ea46a19b6e60e589f"
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
        #{opt_bin}/rtx activate fish | source
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
