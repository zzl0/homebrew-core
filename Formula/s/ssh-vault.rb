class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.0.1.tar.gz"
  sha256 "38bc41c88b540d694591d1c2d911ff799c22ab7b4ffabc5058f05e3830f472f1"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f86981b5062ba4f2382c6be48232248624e0b4a38902d900e5071e6246728731"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25e86b2a90a05442c7e883447d5139fed351bf0c24a1110def35d3cf3130c028"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25e86b2a90a05442c7e883447d5139fed351bf0c24a1110def35d3cf3130c028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25e86b2a90a05442c7e883447d5139fed351bf0c24a1110def35d3cf3130c028"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2d0a3f4a23913ff935e8ee16278f6434eb105e2b0a10597ad535e63c71e090b"
    sha256 cellar: :any_skip_relocation, ventura:        "626b79f4e43c94b0032b7c96971205441e54988955e8cbc741ec380d45ce17f1"
    sha256 cellar: :any_skip_relocation, monterey:       "626b79f4e43c94b0032b7c96971205441e54988955e8cbc741ec380d45ce17f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "626b79f4e43c94b0032b7c96971205441e54988955e8cbc741ec380d45ce17f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e41cb587b634237268bf413e3e8b57925c1a55002598a343f9c7bdd41d7354"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)

    if OS.linux?
      [
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      ].each do |library|
        assert check_binary_linkage(bin/"ssh-vault", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end
