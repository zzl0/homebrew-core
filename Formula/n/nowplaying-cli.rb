class NowplayingCli < Formula
  desc "Retrieves currently playing media, and simulates media actions"
  homepage "https://github.com/kirtan-shah/nowplaying-cli"
  url "https://github.com/kirtan-shah/nowplaying-cli/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "bb49123c66282b6495c245589313afc94875a7b0e82c9ae9f79d6f25e7503db4"
  license "GPL-3.0-or-later"

  depends_on :macos

  def install
    system "make"
    bin.install "nowplaying-cli"
  end

  test do
    assert_equal "(null)", shell_output("#{bin}/nowplaying-cli get-raw").strip
  end
end
