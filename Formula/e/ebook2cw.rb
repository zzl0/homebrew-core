class Ebook2cw < Formula
  desc "Converts ebooks to morse code"
  homepage "https://fkurz.net/ham/ebook2cw.html"
  url "https://fkurz.net/ham/ebook2cw/ebook2cw-0.8.5.tar.gz"
  sha256 "571f734f12123b4affbad90b55dd4c9630b254afe343fa621fc5114b9bd25fc3"
  license "GPL-2.0-or-later"

  depends_on "gettext"
  depends_on "lame"
  depends_on "libvorbis"

  def install
    system "make", "DESTDIR=#{prefix}"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "echo \"test mp3 file generation\" | #{bin}/ebook2cw -o test"
    assert_predicate testpath/"test0000.mp3", :exist?
    system "echo \"test ogg file generation\" | #{bin}/ebook2cw -O -o test"
    assert_predicate testpath/"test0000.ogg", :exist?
  end
end
