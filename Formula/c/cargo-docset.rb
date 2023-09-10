class CargoDocset < Formula
  desc "Cargo subcommand to generate a Dash/Zeal docset for your Rust packages"
  homepage "https://github.com/Robzz/cargo-docset"
  url "https://github.com/Robzz/cargo-docset/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "98e7aec301ad5840d442f6027bba02b41de3f03b1f3c85b23adcc6dd7ca8c415"
  license "Apache-2.0"
  head "https://github.com/Robzz/cargo-docset.git", branch: "master"

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

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

      output = shell_output("cargo docset --all-features")
      assert_predicate crate/"target/docset/demo-crate.docset", :exist?
      assert_match "Docset succesfully generated", output
    end
  end
end
