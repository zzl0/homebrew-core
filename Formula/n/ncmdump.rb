class Ncmdump < Formula
  desc "Convert Netease Cloud Music ncm files to mp3/flac files"
  homepage "https://github.com/taurusxin/ncmdump"
  url "https://github.com/taurusxin/ncmdump/archive/refs/tags/1.2.1.tar.gz"
  sha256 "a1bd97fd1b46f9ba4ffaac0cf6cf1e920b49bf6ec753870ad0e6e07a72c2de2d"
  license "MIT"
  head "https://github.com/taurusxin/ncmdump.git", branch: "main"

  depends_on "taglib"

  def install
    os = OS.mac? ? "macos-" : "linux"
    arch = Hardware::CPU.intel? ? "intel" : Hardware::CPU.arch.to_s if OS.mac?
    system "make", "#{os}#{arch}"
    bin.install "ncmdump"
  end

  test do
    resource "homebrew-test" do
      url "https://raw.githubusercontent.com/taurusxin/ncmdump/516b31ab68f806ef388084add11d9e4b2253f1c7/test/test.ncm"
      sha256 "a1586bbbbad95019eee566411de58a57c3a3bd7c86d97f2c3c82427efce8964b"
    end

    resource "homebrew-expect" do
      url "https://raw.githubusercontent.com/taurusxin/ncmdump/2e40815b5a83236f3feb44720954dd3a02eb00f1/test/expect.bin"
      sha256 "6e0de7017c996718a8931bc3ec8061f27ed73bee10efe6b458c10191a1c2aac2"
    end

    resources.each { |r| r.stage(testpath) }
    system "#{bin}/ncmdump", "#{testpath}/test.ncm"
    assert_predicate testpath/"test.flac", :exist?
    assert_equal File.read("test.flac"), File.read("expect.bin")
  end
end
