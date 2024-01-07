class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/mise"
  url "https://github.com/jdx/mise/archive/refs/tags/v2024.1.9.tar.gz"
  sha256 "82e48b73ad70791337ff0b9e2d06318ecf5d88d98af69b0af0b5d6d8e8e6ae0b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b23e1dd88d425e4796c31ee302360c1736cce87fe6c3290ee33014f67bbde54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cecd0a5766d30e2066473011f1272d35a0e0387bf54eceb749bad9fe2b9c932a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af031158909e4d5505312dab2d6c719700b369c1641c368dade0288dc824702"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac46a777471f43a7e4ff4429b91911b855c7759a9a47e479a7e8f465c86394d2"
    sha256 cellar: :any_skip_relocation, ventura:        "d2e3d7413144982f096650feec7d247574508e5f03e3263f5196c4d239b5233c"
    sha256 cellar: :any_skip_relocation, monterey:       "5be7aec279921bec9d821bb86379bf111ad0df8079d2512793243506e5b10ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8390f6a52de069f14ad0745f7f5cc37c64864a1a1a403d4f919a984f2aab377d"
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
