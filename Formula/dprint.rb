class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.40.2.tar.gz"
  sha256 "06afa0d071a35d759d8f5e480a52c3936c3daa85d1053df48a65fcbb1074683b"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6586f1ab3ea94c4e2c440a34a3adf0a6c3385da8c38492b84fa2e6341cfadac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c58d9ee6fa9ddd64a84243cca0831f1357c9d637350ff1f8a8eab13842dc16ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6684d885a2f18a339a9e8ea95c77ded370d840ac3a66af1812989bb1ac841eb"
    sha256 cellar: :any_skip_relocation, ventura:        "10c5cfab1d0bdffb49db5e9aa608c3f3034a95b33e5712d3ebe9ecada43d5537"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b92a41fda8302f695a81d93e80418a3ebc2c40841aabf2954045fd1bb1cddb"
    sha256 cellar: :any_skip_relocation, big_sur:        "50d7a491cab1b7cae802965b4d146e9a4e0c9c3050d85643710f566b2213818a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f959962221c9dad92dd551fea6f359f2e7d47d9b56607810a181adbf94e22746"
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
