class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "d578e81a4ec1a4ebd3308e9c53591a7496403b016420ad47e7600660e3fd06cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cc31920e4c5bf4961d26abf566d6665d9c801db2c2ba86f962cda5b61373548d"
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
