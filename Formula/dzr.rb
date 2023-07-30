class Dzr < Formula
  desc "Command-line Deezer.com player"
  homepage "https://github.com/yne/dzr"
  url "https://github.com/yne/dzr/archive/refs/tags/230730.tar.gz"
  sha256 "8feebabc002a0520b65bc3a6256ad81c4446d5b54d6c8fac71176b9bb9c764cc"
  license "Unlicense"
  head "https://github.com/yne/dzr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e3ca7733ac4d0dec77a12b4fd7f985d0bd8fbe0e4615e40b2ca08398f42891d0"
  end

  depends_on "dialog"
  depends_on "jq"
  depends_on "mpv"
  uses_from_macos "curl"

  def install
    bin.install "dzr", "dzr-url", "dzr-dec", "dzr-srt", "dzr-id3"
  end

  test do
    ENV.delete "DZR_CBC"
    assert_equal "3ad58d9232a3745ad9308b0669c83b6f7e8dba4d",
                 Digest::SHA1.hexdigest(shell_output("#{bin}/dzr !").chomp)
  end
end
