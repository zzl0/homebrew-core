class CargoAllFeatures < Formula
  desc "Cargo subcommands to build and test all feature flag combinations"
  homepage "https://github.com/frewsxcv/cargo-all-features"
  url "https://github.com/frewsxcv/cargo-all-features/archive/refs/tags/1.10.0.tar.gz"
  sha256 "07ea7112bf358e124ecaae45a7eed4de64beeacfb18e4bc8aec1a8d2a5db428c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/frewsxcv/cargo-all-features.git", branch: "master"

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

      output = shell_output("cargo build-all-features")
      assert_match "Building crate=demo-crate features=[]", output

      output = shell_output("#{bin}/cargo-build-all-features --version")
      assert_match "cargo-all-features #{version}", output
    end
  end
end
