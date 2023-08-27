class CargoDeps < Formula
  desc "Cargo subcommand to building dependency graphs of Rust projects"
  homepage "https://github.com/mrcnski/cargo-deps"
  url "https://github.com/mrcnski/cargo-deps/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "b570902b2225f1cf8af5a33d3b77ac4bf04161ef7e9573731eed97715efa9fd3"
  license "BSD-3-Clause"
  head "https://github.com/mrcnski/cargo-deps.git", branch: "master"

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

      system "cargo", "generate-lockfile"

      output = shell_output("cargo deps")
      assert_match "digraph dependencies", output

      output = shell_output("#{bin}/cargo-deps --version")
      assert_match "cargo-deps #{version}", output
    end
  end
end
