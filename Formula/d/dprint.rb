class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.42.2.tar.gz"
  sha256 "84abc84401a3da676a45748e4341c198bc5ac20ff6bab23b8870284029826684"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cb6fc86ad492dd9cb14bbda979bff52ecc4299c634d2f177b6255e4c9b68bbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab8ea9575d11cbf312e340a125fc28951ad897acf86fa29c38076ca3b0a919f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e79c61f7fe58d792f0ae86447b0acd0269ee5f7d8ae373e233d29d08ddc9cf2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e2e2c67d80eac9cf67814220c763159a9b12a65d73bfc0cbf5e7aec3cf4c716"
    sha256 cellar: :any_skip_relocation, ventura:        "da2fb7bc98942ab53f1a66c4d80fef40ab3eeffd7a8a9c919c00a3fea80a7d01"
    sha256 cellar: :any_skip_relocation, monterey:       "331989578d2b083483c32b0d6a4244c010774a3b096995f5eec69ae659f214d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e00dbe68351384b742a7c37b029c87052280c114eb59c96e7ebded855ace4e"
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
