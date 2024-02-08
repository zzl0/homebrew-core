class Teip < Formula
  desc 'Masking tape to help commands "do one thing well"'
  homepage "https://github.com/greymd/teip"
  url "https://github.com/greymd/teip/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "29147678f3828a3ed83c0462ec8b300307cbe8833ce94ed46016a5bfa3f9b3a5"
  license "MIT"
  head "https://github.com/greymd/teip.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b8236a3ce68ab2062bf453517e5eeee3ca58edd543db01c1065bab68913d5419"
    sha256 cellar: :any,                 arm64_ventura:  "3318cc516cddaa7ab4a31c63edfe1db4a1e911d846c06fa47f582af4b4b36edb"
    sha256 cellar: :any,                 arm64_monterey: "88b1bd22cd5f91736a977181d132ce58aeac3ddbad78a72fb58d50cf8b49e45a"
    sha256 cellar: :any,                 sonoma:         "8e469e75ba52cafb414cda79b1577d6a7a0092a97cfc3a192e8546fd5695c417"
    sha256 cellar: :any,                 ventura:        "1fa2d3d2b009360140e0990c12558ce68843793a560443aed94506b0ac6a1745"
    sha256 cellar: :any,                 monterey:       "b4c73b82a3010e8c2307fbbf1f1cb82cecdbb417654c2be13f39b113d91ed9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945a2668be5d0d4d6a81dbab65a76cf8bd6ba7c12708020623cdee8b4cc24b96"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", "--features", "oniguruma", *std_cargo_args
    man1.install "man/teip.1"
    zsh_completion.install "completion/zsh/_teip"
    fish_completion.install "completion/fish/teip.fish"
    bash_completion.install "completion/bash/teip"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    ENV["TEIP_HIGHLIGHT"] = "<{}>"
    assert_match "<1>23", pipe_output("#{bin}/teip -c 1", "123", 0)

    [
      Formula["oniguruma"].opt_lib/shared_library("libonig"),
    ].each do |library|
      assert check_binary_linkage(bin/"teip", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
