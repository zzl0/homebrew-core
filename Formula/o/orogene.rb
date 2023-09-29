class Orogene < Formula
  desc "`node_modules/` package manager and utility toolkit"
  homepage "https://orogene.dev"
  url "https://github.com/orogene/orogene/archive/refs/tags/v0.3.31.tar.gz"
  sha256 "06105fde1116958e97db8be1ccf4734bcecd8d4282e6c6c27ae9929fa51a2ac8"
  license "Apache-2.0"
  head "https://github.com/orogene/orogene.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oro --version")
    system "#{bin}/oro", "ping"
  end
end
