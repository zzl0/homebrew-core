class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.1.1.tar.gz"
  sha256 "a7da6602c70e22d38bb6759d9f86bbcbd1c066e5bbe17f258b6185258f379558"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a2f68186f97ac3503ee05cc4cc2f20ccd632b5172242a4a26d5df50d44939e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cb17eb4cec8958cbd798f1ae5140e8c80789e54dc2e3d4c69097921369b38af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e49af3d9a2243394add84616e02c8e2505a800af198ffabc695272ff5703b651"
    sha256 cellar: :any_skip_relocation, ventura:        "ce1f6b15cfdfd394a39151a98fd9a3d6f563eec61647d426081f699d20979291"
    sha256 cellar: :any_skip_relocation, monterey:       "83f46e535672b412509ecb5130929017a57f5571b664a15a9da983a7191236d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bfe730243707288d89d8d60a713b12541fce2fd90f02f829af051c47d1b6412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e28be8bbc8add9c6a3d7027d6b9cbab5fc36d20d482c51c7ceceda60d08d6b93"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "systemd"
  end

  def install
    # FIXME: Figure out why cargo doesn't respect .cargo/config.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
