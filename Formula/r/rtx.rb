class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.12.34.tar.gz"
  sha256 "691a7a749557b10fd3f5cac0a05af7b222627f507e2b114095048f215d9a0716"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b100f4c81c95d22f64e888c4d97e69279dbe711079bb826f96f9c8b4d24c6501"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b86ebf5f26267a45080e3a77e467d113480d5fa3c540b01b914fb1c39abe5d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17eff628d81e8ee2111ce5e2626562c1749f5923c9238562c4eb50ba4af09805"
    sha256 cellar: :any_skip_relocation, sonoma:         "767074699669e7702a84ccca5566d04ebd353bc581e9c79cd7690dac777cdf64"
    sha256 cellar: :any_skip_relocation, ventura:        "989c78293321e1ea6df718142846b40add05e0b5a4929bba7e2350fbe2b2e6c1"
    sha256 cellar: :any_skip_relocation, monterey:       "3004b7f77883a98f92ad3fc630ebac61c8854dabb4708bed91a7a26bb73ad94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0ea7e689464381314756ce4c90c520e73762f36c39d5a69a96ea4bb1bb4f14e"
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
