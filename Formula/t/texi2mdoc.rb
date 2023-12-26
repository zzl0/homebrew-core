class Texi2mdoc < Formula
  desc "Convert Texinfo data to mdoc input"
  homepage "https://mandoc.bsd.lv/texi2mdoc/"
  url "https://mandoc.bsd.lv/texi2mdoc/snapshots/texi2mdoc-0.1.2.tgz"
  sha256 "7a45fd87c27cc8970a18db9ddddb2f09f18b8dd5152bf0ca377c3a5e7d304bfe"
  license "ISC"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    share.install prefix/"man"
  end

  test do
    (testpath/"test.texi").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS

    output = shell_output("#{bin}/texi2mdoc #{testpath}/test.texi")
    expected_outputs = [/\.Nm\s+test/, /\.Sh\s+Hello World!/]
    expected_outputs.each do |expected|
      assert_match expected, output
    end
  end
end
