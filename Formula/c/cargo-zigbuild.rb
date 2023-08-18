class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https://github.com/rust-cross/cargo-zigbuild"
  url "https://github.com/rust-cross/cargo-zigbuild/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "5ed6d4a01a7fe14e8a9408dd2d3835b0ead3cf435963c1724ef2f79cff0873a0"
  license "MIT"
  head "https://github.com/rust-cross/cargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e69fbc0077cc6c872fc8ab5348cf0f0b66903a91b5e2856f98f6872dde5f2439"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12e95ce26b9b9f73447f8650686a072c14fb1dc41ad8adb3957c86ade57d896b"
    sha256 cellar: :any_skip_relocation, ventura:        "0cfb773501818661a7f527c9876f1fff9ac25373c695661dcf2c48361a6a10e1"
    sha256 cellar: :any_skip_relocation, monterey:       "f98a4ff0aa126cc0f75e43ffb9f85dbfee164ba7519b48a6bb3eb282475bd852"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bd92603c56981c46a8f528afa0e99b09ce4bb1ea15170c5bf8db5f1d365ea64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eaea61399c51dafbc54bcd85e7e7a598863c6863545c6ee827ab11a5a935a1c"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Ignore rust installation path check
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu.2.17"
    end
  end
end
