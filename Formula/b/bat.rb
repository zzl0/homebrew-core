class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for details.
  url "https://github.com/sharkdp/bat/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "30b6256bea0143caebd08256e0a605280afbbc5eef7ce692f84621eb232a9b31"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8177a3ddab18619e77116cbfe59d4d2c03a6aaeba042601390a92d22aa08a46d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "276919443822ce3cc55843e43843b811cf8db79dcc879d287158753ec1cd4075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8433bab46de75d78ea184a79662a74c8fa7cc087236fe5b29f1a48f5d06c94ed"
    sha256 cellar: :any_skip_relocation, ventura:        "8ff93e5f116859666cf9f147d90c06e0fe53b80d31370b20f0f123ae322f68fd"
    sha256 cellar: :any_skip_relocation, monterey:       "863269989acbd5d931811547313b6fd98f9acbaeb483cd254ecf418b9d19c4f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "28aba91680d3a12e54157f6ee7dda049198509a0a4bfdf14a44248a4a9597022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062b61c453c47e891a03cf9000b319d30f71988acd4b9cd8a083071d0f831028"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/sharkdp/bat/blob/v#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.5.*, then:
  #    - Use the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.5"
  depends_on "oniguruma"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    assets_dir = Dir["target/release/build/bat-*/out/assets"].first
    man1.install "#{assets_dir}/manual/bat.1"
    bash_completion.install "#{assets_dir}/completions/bat.bash" => "bat"
    fish_completion.install "#{assets_dir}/completions/bat.fish"
    zsh_completion.install "#{assets_dir}/completions/bat.zsh" => "_bat"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output

    [
      Formula["libgit2@1.5"].opt_lib/shared_library("libgit2"),
      Formula["oniguruma"].opt_lib/shared_library("libonig"),
    ].each do |library|
      assert check_binary_linkage(bin/"bat", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
