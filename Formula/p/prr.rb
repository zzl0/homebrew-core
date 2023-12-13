class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "4f81770aa28661bb3cc880507ec9d56b46f8d26310acca1efcc6cc29571c0531"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c4090b1619a36b5a561d6c35edb9015eb1b11dfc6304cc653d5273dc9386963"
    sha256 cellar: :any,                 arm64_ventura:  "6c5d48e1b9fa46864bac608f1e91a6d34e1515f8b4f8b6f74050cd1dbc411f64"
    sha256 cellar: :any,                 arm64_monterey: "2969893f0070442a91452b2d32f12c48142b82c75cbadfc7f68ba45b42476878"
    sha256 cellar: :any,                 sonoma:         "f3ba4f65de66424fb0ca8f07660a711ba8c7bd072f284db877a5d5657fc64f1c"
    sha256 cellar: :any,                 ventura:        "2d98039e5a7fe041c8bd0eb4d7c8e536492bdc97016a51deb426c76fa3a3012a"
    sha256 cellar: :any,                 monterey:       "0ec7fda34a0494a898244d1889f017e01ba9838378d5f86334a9b61e6efd31f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ae6f73a6aca6e0e26cb46c26ef9b0459fec89958d2a7a4b71c8aa2b2fed512"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"prr", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
