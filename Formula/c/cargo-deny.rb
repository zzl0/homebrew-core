class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.8.tar.gz"
  sha256 "f6eb0a9bfeca201b9ccf9910d63426a48c6d1397b22f5c2b68e9276d6ff1d495"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b93b1adb8b7387e02f8ae8976c255c906ef74965e62b00109c09c7d28c549449"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "474148cb7897aa5c4a3b668d2560d96a143bf6df01b11cf7356644b2eb871c4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8448dc5e03dfede97bf5a570d5eac2cf22f1bcd369ad5bf7491735c9143a93d"
    sha256 cellar: :any_skip_relocation, sonoma:         "daada84a3c7952bc3379e80b980b890dd30c2328adb2c63cea660f434421114c"
    sha256 cellar: :any_skip_relocation, ventura:        "bf39e6bda52098ef04925a9f9499b1b1233f5406a6ae046d1b774caafe1b3eaf"
    sha256 cellar: :any_skip_relocation, monterey:       "db8c98a5cfd3f6e4bd2f4f0b759873347cc21a4dcdeddaa97f1e86264f9aa544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07b2116465af1de0243130068b8630bae90b5322eeb9f76ed55740c6cbd05cce"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test

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
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
