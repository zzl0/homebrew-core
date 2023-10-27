class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.42.0.tar.gz"
  sha256 "5676259395e171f41b605df9096ca44abee4d0ff89b1e31514b7b97018bbb804"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0216c6b2f6f597e5fa6f62076d9643932365c50fd7329668ec15c610b620582f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c7abc484289881d25174942cef0923c1bc6487b0653151bb146a44728ce2d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e1a4f20cf53187bff279c551840575c3c253c2d8ebdbc880b5ce62d3950b37e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c9fb23851f67285d096c20baa1753716434a2c53562661840952e0c0f54c0b5"
    sha256 cellar: :any_skip_relocation, ventura:        "7bf1bc17ee6cf5b0f0f717228c8ba1dbe273e2ebdfda64163e9b44ee1d5fe6f5"
    sha256 cellar: :any_skip_relocation, monterey:       "07c7af9293fdc08051e9ac697e289af768127034843b7c9f8174174607472df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "604360f139ff7c019c3abc27f4648a8e3bf24f466d8a5828b632774aceff809a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
