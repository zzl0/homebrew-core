class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.10.tar.gz"
  sha256 "c8c157f46ddbeea80da79f6bb13814730c88dd18c5d1f1c9c67247ac48f74237"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58ef04b9766aa0c7a001c6eea1450cd9350c9b530586c217cdad9bbe23a5ab97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13fba1d24cfd4b12a4b0eb28306da36c7c40691d029a9bb9889601ae8568d9a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15d1dcc2382a7d8390ec9cdd7296724fd399727afcded718b7666c85e1129c50"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa6accedf019ca2e4572a80513e5807f58605241cb88f9bd305f8b59e5f0797b"
    sha256 cellar: :any_skip_relocation, ventura:        "9207668087f485b83d1d35e32be0ba1e62f5c88f9d480f135c7fe8c2a7f429b5"
    sha256 cellar: :any_skip_relocation, monterey:       "8dee733d7d5afe7aeb055d7389dbd42b48771c8d590197add322c0ae05871744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2319865fb5bc4871a1271922c22bf69c64c1fa9ad8d23731d2e3260515027084"
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
