class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://github.com/o2sh/onefetch/archive/refs/tags/2.19.0.tar.gz"
  sha256 "e6aa7504730de86f307d6c3671875b11a447a4088daf74df280c8f644dea4819"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6dc4cc26db8fc147540961f52d1f7cee2693f7b81a1e6b394da3bb5299d4af53"
    sha256 cellar: :any,                 arm64_ventura:  "13491ecb6b14e676dd75eada2c98a52bd72afecd0335bd9c39f7795aa24ff20d"
    sha256 cellar: :any,                 arm64_monterey: "6715b79a60fc0d1572f5abbba2c841d7be4420aa75114f4cc3467e6013ae15d0"
    sha256 cellar: :any,                 arm64_big_sur:  "b1c8a32b3f992d09d4e0f87fb7a536bf56fe04dd6c288289efa743358b03901a"
    sha256 cellar: :any,                 sonoma:         "0f87b3f2862d2077d9a3a853fbd4654c5d333ca7a48f689bd011e89f38ea3102"
    sha256 cellar: :any,                 ventura:        "6cf0339a4c6fab1fa624b77e3ddeaa1dfba966adacc7a1e0aa820fe3dd02abb0"
    sha256 cellar: :any,                 monterey:       "2747b0fece549cd8c75a38d69753b684777f7a52cd7be130b341451ffc8273f9"
    sha256 cellar: :any,                 big_sur:        "5ad3dce345afb2f2b87287bb07ba69a3ecdb9f51c526b628f2e92a7766ed623b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e8c88c3adf425e057cf7a0797d2c94d92a974f4bde6389848d9bf22b33615e3"
  end

  # `cmake` is used to build `zlib`.
  # upstream issue, https://github.com/rust-lang/libz-sys/issues/147
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "zstd"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["ZSTD_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"main.rb").write "puts 'Hello, world'\n"
    system "git", "add", "main.rb"
    system "git", "commit", "-m", "First commit"
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)

    linkage_with_libgit2 = (bin/"onefetch").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
