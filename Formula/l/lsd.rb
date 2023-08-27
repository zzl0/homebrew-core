class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/v1.0.0.tar.gz"
  sha256 "ab34e9c85bc77cfa42b43bfb54414200433a37419f3b1947d0e8cfbb4b7a6325"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cef8b9164d7907fd6262ca87dbb76b7fac3299b90bd8aaf77e648fe2c16e47d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e11daecb5477e2ae9b2f50a794c9b5b1ae743d2919dcec246f7847defc713c21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88600adc3058f94ba3b2251ffc0922fb56562bb03a9f702c78ce25e56aa2ba9e"
    sha256 cellar: :any_skip_relocation, ventura:        "243288af0ca893419f121aada1428918fe65299874c7c72fdbf123d785f09816"
    sha256 cellar: :any_skip_relocation, monterey:       "13e032fca1bd1b05a3f849616a003a2e2916e6028b46d5f22cfab4525651d546"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8dddf65721edbac80730054a73eb92972486fe4aafbcc400378044abd432653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e19ccd2a5f0ca61d4d6638e71bafa19a8eb19a774e323f2897639ed1e45c0e"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"

    system "pandoc", "doc/lsd.md", "--standalone", "--to=man", "-o", "doc/lsd.1"
    man1.install "doc/lsd.1"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
