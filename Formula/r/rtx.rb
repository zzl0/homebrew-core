class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.12.36.tar.gz"
  sha256 "a2d26b44ebc86bdc88c67935eee3c1d6890f789c94230b6f490de9e2063d8e6f"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76f286b6cb44cc768423f08f64828a8e7558583265bc84c7f46f5befabd16aa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1a4722c0a48801634f41ba4a9fb8a4824d43fb8f6a8fcfef6bd56c47db5d4fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbe470941bc88974dbe6fc8be39b294b76b741a250f458f414ca3f06699e685f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd7e50f30f12641fe957859da6f4af03559968566f179859ae8a74cd31f91fc6"
    sha256 cellar: :any_skip_relocation, ventura:        "042cac289a753942f99c0a5c2730891326f584bb549b5adbb53674391116a0ef"
    sha256 cellar: :any_skip_relocation, monterey:       "e1c927c138ef95f64065d906655d124a06dc9ea6b2e888d7574513bb7d7eb7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3d4c3f9051f387ac977c77bbcc2244532b7233ec7873f7e94c4223e8bf7313"
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
