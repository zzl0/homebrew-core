class CargoBinutils < Formula
  desc "Cargo subcommands to invoke the LLVM tools shipped with the Rust toolchain"
  homepage "https://github.com/rust-embedded/cargo-binutils"
  url "https://github.com/rust-embedded/cargo-binutils/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "431fb12a47fafcb7047d41bdf4a4c9b77bea56856e0ef65c12c40f5fcb15f98f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-embedded/cargo-binutils.git", branch: "master"

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"
    system "rustup", "component", "add", "llvm-tools-preview"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        fn main() {
          println!("Hello BrewTestBot!");
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      EOS

      expected = if OS.mac?
        "__TEXT\t__DATA\t__OBJC\tothers\tdec\thex"
      else
        "text\t   data\t    bss\t    dec\t    hex"
      end
      assert_match expected, shell_output("cargo size --release")

      expected = if OS.mac?
        "T _main"
      else
        "T main"
      end
      assert_match expected, shell_output("cargo nm --release")
    end
  end
end
