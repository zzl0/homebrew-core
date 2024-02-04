class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.69.3.tar.gz"
  sha256 "5cdaa156403841e7b286ccbb7b31398c8b49b99f89ebf329457101819aa5eaf0"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10b018336661c58918db629e4c29e8a88010eeff445c954c2814cce7d5fce408"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c55db5398a0b0901e85267134b358a5609278d3bdc1ae1eb31b58f8be25a3b01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d318e0ba66e97e15e88d52bb629fc2540209a3b451cf0bc18078a0ff0e43bd82"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d58e3b2e1723667fe3817c4cadbf35c52b3a51129231d097c477e4f4ca674df"
    sha256 cellar: :any_skip_relocation, ventura:        "b40a16d012298c1b2dba890820992f865f7c2aac350f9390762fffecce71a566"
    sha256 cellar: :any_skip_relocation, monterey:       "1c2088d7fdb074740601c4abf01d9ddc6f368520f1f9ef7905b89d98f9851780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00925dd1c2117808f266425b827994790ed8036efca520224e6152c54fd1e48e"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")

    generate_completions_from_executable(bin/"bindgen", "--generate-shell-completions")
  end

  test do
    (testpath/"cool.h").write <<~EOS
      typedef struct CoolStruct {
          int x;
          int y;
      } CoolStruct;

      void cool_function(int i, char c, CoolStruct* cs);
    EOS

    output = shell_output("#{bin}/bindgen cool.h")
    assert_match "pub struct CoolStruct", output

    assert_match version.to_s, shell_output("#{bin}/bindgen --version")
  end
end
