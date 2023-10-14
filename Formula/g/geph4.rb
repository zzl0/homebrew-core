class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.9.6.tar.gz"
  sha256 "8a5258fbf2423af2ece951b140e91bc7b74acd0139e626ad19b3e9cd3fb9380f"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b71868aa4caa8e47f55800d4841d943539d4ced47c7d71ed1a31f618cf5f5c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de7d1b7fa613ecdaeb9eb0cd76d1b89651d337d9adc7d0e4e3a28ecf62dd800a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6e5373af90d8ac1a52e71ef6d371013b8d31f04384722c09d992bb93f2af3b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7625fb0438bba17ec6a1d00c25c39af97459504c06a0561a24ac82260aecacdb"
    sha256 cellar: :any_skip_relocation, ventura:        "3643e7e01aba5c67d09c113537ea399ed68a894b40e3167bf117f5b055fb2470"
    sha256 cellar: :any_skip_relocation, monterey:       "8a8d90f9850a0c3597ba1c95a8e6b4e4cf3cb39be42db29ad7195d92b440cea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4750628beb596b6707b835367f85eeb9c0c69fdf0dd3312e2c3c33bc17c154ea"
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

    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid credentials",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
