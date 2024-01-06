class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "8a8b737aff1361677e3733133944728871ccf7ac00ea15b32f9d0ef6d5814f62"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d65f4d3fc402db741fbffb31dcc5f030452b61ac9211b7ffc1ca2ade212cfa4"
    sha256 cellar: :any,                 arm64_ventura:  "5d800aecb1e4bb6f196eed1af738ccab2e88710975e516ad361edac18a6766e6"
    sha256 cellar: :any,                 arm64_monterey: "3ba3bdb6b262d8ea87030932c369d29aaff5896581df6dbf6edbd9138ce0e02d"
    sha256 cellar: :any,                 sonoma:         "49375d0272a2a678333bf2567e074b51760de9305b1c2b7c1e5b72eb80d820ac"
    sha256 cellar: :any,                 ventura:        "6e61f6e375c30de02aad9e4bca7a9048f25c78d79ec1d771b59548b1ca27ce29"
    sha256 cellar: :any,                 monterey:       "c1bbabe03ed844026df06704ae120d07400025bbdb6996447056b1cf0ced638e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cacdb2f98114ea7cdda438b24d03f1314118fcb45eb135e423a77c399ccbead8"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./cargo-crev")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "crev", "config", "dir"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-crev", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
